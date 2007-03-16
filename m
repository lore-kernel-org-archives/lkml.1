Return-Path: <linux-kernel-owner+w=401wt.eu-S965844AbXCPTDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965844AbXCPTDg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 15:03:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965854AbXCPTDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 15:03:36 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:24320 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965844AbXCPTDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 15:03:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lYNsPsbW/c/U/00tj/0+6x3a/HKjPTpeFWfXpz81K5xKfupIV4D7UZaq4rD1S+D72QJRM5YExJgC64gzvrD6Ax0jJ8WG2m+o6vcN6ytlm7Ato9l85CApdj9C/rAhUxM8TFdIx4VB6Fs/podEUEKO+/zqWL7csuvIgQhdNgpi4G8=
Message-ID: <6bffcb0e0703161203v699d9b21x8fa6bf5175916441@mail.gmail.com>
Date: Fri, 16 Mar 2007 20:03:29 +0100
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Takashi Iwai" <tiwai@suse.de>
Subject: Re: Linux 2.6.21-rc4
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <s5hbqitj9xi.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
	 <45FAD77A.1070709@googlemail.com> <s5hbqitj9xi.wl%tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/03/07, Takashi Iwai <tiwai@suse.de> wrote:
> At Fri, 16 Mar 2007 18:44:26 +0100,
> Michal Piotrowski wrote:
> >
> > Takashi, unfortunately this bug isn't fixed
> > http://www.ussg.iu.edu/hypermail/linux/kernel/0703.0/index.html#1684
>
> The patch wasn't merged to rc4.

I know. I use patched 2.6.21-rc3-git4 for crashdump.

> Or, do you mean the bug is still present even with the patch?

This patch doesn't fix the problem.
http://www.ussg.iu.edu/hypermail/linux/kernel/0703.0/3080.html

Tomorrow, I'll try to provide more info about this problem.

>
>
> Takashi
>

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
