Return-Path: <linux-kernel-owner+w=401wt.eu-S1754195AbYLCRYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbYLCRYu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 12:24:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751453AbYLCRYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 12:24:41 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:7314 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbYLCRYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 12:24:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=dM2OaHqgTE2COrGDZxivlqmdL8JukoD9VQD7q2x7L2WzRG/WGGP5r7XsdtKQkEQRFo
         et6752Z/OuBkFF06VJLYl/IzLqmQnyRkx0HrDWmPOr5bgKrEUNnx+XOgtRSFppJhWmSH
         Rws0nWjrn36tSCyT2fCc97QGStvgelCTesMgw=
Message-ID: <38b2ab8a0812030924g5391fdbdy15c472a51ab24aef@mail.gmail.com>
Date: Wed, 3 Dec 2008 18:24:38 +0100
From: "Francis Moreau" <francis.moro@gmail.com>
To: "Renato S. Yamane" <yamane@diamondcut.com.br>
Subject: Re: About git-bisect
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Sam Ravnborg" <sam@ravnborg.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <493681B7.20101@diamondcut.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <bEuTZ-3Ya-5@gated-at.bofh.it> <bECot-57C-1@gated-at.bofh.it>
	 <bEFPF-XO-15@gated-at.bofh.it> <bEFPG-XO-19@gated-at.bofh.it>
	 <bEG8P-1xl-15@gated-at.bofh.it> <bEGiz-1Hw-11@gated-at.bofh.it>
	 <bEGLI-2aS-31@gated-at.bofh.it> <bEGVc-2Bk-11@gated-at.bofh.it>
	 <m2r64q6y8e.fsf@gmail.com> <493681B7.20101@diamondcut.com.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 3, 2008 at 1:55 PM, Renato S. Yamane
<yamane@diamondcut.com.br> wrote:
> Francis Moreau wrote:
>> Linus Torvalds writes:
>>> It takes me 16 seconds to compile my kernel (if it's all cached), and
>>> that's largely because I do _not_ compile one of the crazy distro kernels
>>> with thousands of totally irrelevant modules for my setup.
>>
>> an other reason is perhaps you're using a computer that most common
>> mortal don't have ;)
>>
>> Care to share your network configuration ;) ?
>
> Maybe a repository with .config files used by linux hard-users (as most
> developers here) can be very interesting to a lot of people get a starter.
>

Or perhaps just to keep 'make defconfig' uptodate with sane core values
which should fit a desktop config ?

BTW does anybody what the status of the defconfig files on x86 ?

thanks
-- 
Francis
