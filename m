Return-Path: <linux-kernel-owner+w=401wt.eu-S1753993AbYKQSfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993AbYKQSfQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 13:35:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752078AbYKQSfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 13:35:04 -0500
Received: from wf-out-1314.google.com ([209.85.200.175]:8120 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074AbYKQSfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 13:35:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=tlGyeLWZ6qdqclXzIZzH1PCxGWA1a9rCjDmt8wDoAc2rTwUdLYreitMpqr7ncEGbeQ
         CSRpr6Q/l1IeYm5ZyxfGmVpH5AOC5vFrAYcguhUD2ik4W4IKHYvX58VIIHMjV8IPildj
         GpYvatX0mrWlrRuGzO3cJI4rByGRNkEMPLOD0=
Message-ID: <41840b750811171035w63c794aepaa273bc55fbaf2@mail.gmail.com>
Date: Mon, 17 Nov 2008 13:35:01 -0500
From: "Shem Multinymous" <multinymous@gmail.com>
To: "J.R. Mauro" <jrm8005@gmail.com>
Subject: Re: [Tpctl-users] Inclusion of tp_smapi module into kernel?
Cc: "H. Peter Anvin" <hpa@zytor.com>, tpctl-users@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <3aaafc130811170913o761ce43fg3a2738586ebd2396@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200811171455.50039.hanno@hboeck.de> <49219DF5.5040404@zytor.com>
	 <3aaafc130811170913o761ce43fg3a2738586ebd2396@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2008 at 12:13 PM, J.R. Mauro <jrm8005@gmail.com> wrote:
> There are several utilities maintained by this author, and finding
> some way to merge the code has been tried more than once. If you look
> back far enough, Andrew asked to have another of the project's members
> sign off on the patch, and maybe that would be acceptable enough, but
> afaik the author has never responded directly to that idea.

We've discussed that in private at the time, and recently on LKML too.
In summary:
I'm fine with that, and so is everybody I talked to (including Linus),
except Greg KH who vetoed it since he believes the code is irrevocably
and contagiously evil.

  Shem
