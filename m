Return-Path: <linux-kernel-owner+w=401wt.eu-S1755873AbXD0Obl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873AbXD0Obl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 10:31:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755960AbXD0Obl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 10:31:41 -0400
Received: from nz-out-0506.google.com ([64.233.162.227]:54662 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755873AbXD0Obj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 10:31:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=IAgE3OlYH+ZmReyJ2Dy07w8uYEqn2HEAT0+L+UQevN4j7PSc/5KCVD/lieoPr+A5YNPWCQuy43qU3hbgv1hlpspXbKP5i1Sv5tKXA1ahRWBNxSPPTZGQgjEPOoTATOVeKZy4sgc9aGb4WXOE7KN9raqKAtthL3c78Z+/zhX9xj0=
Message-ID: <8355959a0704270731k97da30anf1c010f7ae3dc18c@mail.gmail.com>
Date: Fri, 27 Apr 2007 20:01:37 +0530
From: "Sunil Naidu" <akula2.shark@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21 - something wrong with dmesg.
Cc: "Frederik Deweerdt" <deweerdt@free.fr>,
       "Alistair John Strachan" <s0348365@sms.ed.ac.uk>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <200704261535.46568.s0348365@sms.ed.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8355959a0704260514s39afa1ecj3e7e077e482769a8@mail.gmail.com>
	 <20070426130339.GB16833@slug>
	 <200704261535.46568.s0348365@sms.ed.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/26/07, Alistair John Strachan <s0348365@sms.ed.ac.uk> wrote:
> >
> > Don't you need to increase CONFIG_LOG_BUF_SHIFT ?

Yep, I need to. But, have to enable the Kernel Debug (DEBUG_KERNEL) to
increase the value from default 14 value to 15/16. I feel that this
might increase the kernel size?

Ummm, is it possible to move CONFIG_LOG_BUF_SHIFT under the General
Setup area? (say, down the Kernel .config support - IKCONFIG).

Comments pl?

> (Also, does Andrew really need to be CCed twice?)

I agree with you - my apologies to Andrew ;-) (shall bug him @ linux
foundation only)

> Alistair.
~Akula2
