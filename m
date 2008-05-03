Return-Path: <linux-kernel-owner+w=401wt.eu-S1756850AbYECXsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850AbYECXsp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 19:48:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754889AbYECXsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 19:48:37 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:46537 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068AbYECXsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 19:48:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DPpiNpwI8AtQmG0ZMC6iUBiANJbpPo/lKREbIc95RCOJQTxZWwVnlHw+gn3K0m0M+2IpglGEKCkMwg8Uwip96j4aDHDhsXQXhu1OAQv1qwgG6QHL5OSCS1cjoslgWeYpSQAEV7QLQIsdthYAJ+wsAC2B+uljXfqEyX01I0RjgNs=
Message-ID: <dd18b0c30805031648x562beaabwff47e721acddc0e9@mail.gmail.com>
Date: Sat, 3 May 2008 23:48:35 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: nopage mm.h
Cc: npiggin@suse.de,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080503233818.GZ5838@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30805031629x5f570b97q43f110b228054a28@mail.gmail.com>
	 <20080503233818.GZ5838@cs181133002.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 3, 2008 at 11:38 PM, Adrian Bunk <bunk@kernel.org> wrote:
>
> On Sat, May 03, 2008 at 11:29:20PM +0000, Justin Mattock wrote:
>  > Hello; I have a question about the nopage function that was removed in
>  > the kernel.
>  > What would be the best way for me to build a module that has a nopage
>  > funtion in it?
>  > Right now I went and undid what you had done to the kernel,to atleast
>  > have the module not give me errors,
>  > but, am wondering if I should try to take the module and remove the
>  > nopage function in it , and add the functions that is relevent.
>  > to keep the module up-to date.
>
>  Where can we find the source code of your module?
>
>  > regards;
>
>  cu
>  Adrian
>
>  --
>
>        "Is there not promise of rain?" Ling Tan asked suddenly out
>         of the darkness. There had been need of rain for many days.
>        "Only a promise," Lao Er said.
>                                        Pearl S. Buck - Dragon Seed
>
>
The module is fglrx.
regards;


-- 
Justin P. Mattock
