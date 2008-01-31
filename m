Return-Path: <linux-kernel-owner+w=401wt.eu-S933661AbYAaXC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933661AbYAaXC7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 18:02:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754274AbYAaXCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 18:02:52 -0500
Received: from rn-out-0910.google.com ([64.233.170.189]:31910 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754171AbYAaXCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 18:02:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XVZUg7xeSStU/q8ntbdyfJwFi6oBGA1PYO1EclYC/rWCCg9a+RxL2qMQybV4im+WMjfQJGiXR4LoAjwU4qCItvDkhuWU05lry2ZblBi/ANGyC33TfM66IIHalOsCOax9T7c7vEHJO3baZEXXukeR+/za/iJDQc6LCwoCGCQmmkc=
Message-ID: <4d8e3fd30801311502m3d022b87h4dc0095340225b8a@mail.gmail.com>
Date: Fri, 1 Feb 2008 02:32:47 +0330
From: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/7] X86: Clean up arch/x86/math-emu/errors.c
In-Reply-To: <20080129000721.68d6bfdd@paolo-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080129000721.68d6bfdd@paolo-desktop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/29/08, Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com> wrote:
> Hi all,
> this patch series implements a few clean up suggested by
> checkpatch.pl
>
> I compiled tested every single patch and verified that
> the clean up only patches are not modifying the md5sum of
> the relative .o file.
>
> Before the patches:
> total: 214 errors, 28 warnings, 739 lines checked
>
> After:
> total: 2 errors, 1 warnings, 674 lines checked
>
> arch/x86/math-emu/errors.c |  431
> +++++++++++++++++++-------------------------
>  1 files changed, 183 insertions(+), 248 deletions(-)
>


Ingo, are you interested in these patches?

#7 can be discarted
#6 needs to be redone
#3 is unclear
#1,2,4,5 should be ok

ciao,
-- 
Paolo
http://paolo.ciarrocchi.googlepages.com/
