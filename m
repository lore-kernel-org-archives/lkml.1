Return-Path: <linux-kernel-owner+w=401wt.eu-S1752767AbYKQTVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767AbYKQTVm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 14:21:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751709AbYKQTVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 14:21:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42646 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbYKQTVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 14:21:32 -0500
Message-ID: <4921C425.7020806@zytor.com>
Date: Mon, 17 Nov 2008 11:21:09 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Shem Multinymous <multinymous@gmail.com>
CC: "J.R. Mauro" <jrm8005@gmail.com>, tpctl-users@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [Tpctl-users] Inclusion of tp_smapi module into kernel?
References: <200811171455.50039.hanno@hboeck.de> <49219DF5.5040404@zytor.com>	 <3aaafc130811170913o761ce43fg3a2738586ebd2396@mail.gmail.com> <41840b750811171035w63c794aepaa273bc55fbaf2@mail.gmail.com>
In-Reply-To: <41840b750811171035w63c794aepaa273bc55fbaf2@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shem Multinymous wrote:
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
> 

Signed-off-by is about copyright, it's not a review issue.  It means "I 
certify that I know that the author had the rights to submit this code." 
   Code quality is important but separate.

	-hpa
