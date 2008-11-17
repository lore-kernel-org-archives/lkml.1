Return-Path: <linux-kernel-owner+w=401wt.eu-S1752757AbYKQSt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757AbYKQSt0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 13:49:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751468AbYKQStK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 13:49:10 -0500
Received: from rv-out-0506.google.com ([209.85.198.227]:41554 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbYKQStJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 13:49:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=QEnR8PvZwxgfxGWm0mHYNEFZR4jC2oWagAGFoxdMNdXW82MNfo8wFfLr/dplpe2FuL
         fkWs5TJLgMBTAQtV6kgZ8AKPiUw57LgC+33vyW4MqPnJwDe0RqffpxQ7BHtbIPXNtvKf
         zfXIawde5yI1RBY4jeAVvhE5ZgGbL/90zRC24=
Message-ID: <3aaafc130811171049l473fbc60h36ba26f048ac986f@mail.gmail.com>
Date: Mon, 17 Nov 2008 13:49:08 -0500
From: "J.R. Mauro" <jrm8005@gmail.com>
To: "Shem Multinymous" <multinymous@gmail.com>
Subject: Re: [Tpctl-users] Inclusion of tp_smapi module into kernel?
Cc: "H. Peter Anvin" <hpa@zytor.com>, tpctl-users@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <41840b750811171035w63c794aepaa273bc55fbaf2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200811171455.50039.hanno@hboeck.de> <49219DF5.5040404@zytor.com>
	 <3aaafc130811170913o761ce43fg3a2738586ebd2396@mail.gmail.com>
	 <41840b750811171035w63c794aepaa273bc55fbaf2@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2008 at 1:35 PM, Shem Multinymous <multinymous@gmail.com> wrote:
> On Mon, Nov 17, 2008 at 12:13 PM, J.R. Mauro <jrm8005@gmail.com> wrote:
>> There are several utilities maintained by this author, and finding
>> some way to merge the code has been tried more than once. If you look
>> back far enough, Andrew asked to have another of the project's members
>> sign off on the patch, and maybe that would be acceptable enough, but
>> afaik the author has never responded directly to that idea.
>
> We've discussed that in private at the time, and recently on LKML too.
> In summary:
> I'm fine with that, and so is everybody I talked to (including Linus),
> except Greg KH who vetoed it since he believes the code is irrevocably
> and contagiously evil.

Does Greg know that both Linus and Andrew have ok'd a second signoff?

>
>  Shem
>
