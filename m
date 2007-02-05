Return-Path: <linux-kernel-owner+w=401wt.eu-S1751641AbXBEQVK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751641AbXBEQVK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 11:21:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751648AbXBEQVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 11:21:10 -0500
Received: from nz-out-0506.google.com ([64.233.162.237]:46230 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbXBEQVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 11:21:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Jdlouje4XYPyWcAkv6Mwe+hy2153XarFuREqes1Tnzjf9RVzZrsPm9xK4o6QDm2aXC64tl2WUZYJQwdRW+syrNKtKSOCHrbSSETYIxHHwUaod38P8L4g10xC5bEMiW2ZtRcHinmUchjHUo7aFThNi55IigNFeqsH2T/bNPq8L8s=
Message-ID: <8d158e1f0702050821m53596327hdf20e29a7cd83ab@mail.gmail.com>
Date: Mon, 5 Feb 2007 17:21:05 +0100
From: "Patrick Ale" <patrick.ale@gmail.com>
To: "Robert Hancock" <hancockr@shaw.ca>
Subject: Re: hdparm for lib_pata
Cc: Stephen.Clark@seclark.us, linux-kernel@vger.kernel.org
In-Reply-To: <45C73DD8.7070309@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.L/RjDlo6Njb5Jt7/9ENZuiASoV0@ifi.uio.no>
	 <45C4DF2A.1070501@shaw.ca> <45C5178A.1000501@seclark.us>
	 <8d158e1f0702031544h6c5f81c7s3c54a6192255d447@mail.gmail.com>
	 <45C5249B.8020101@seclark.us>
	 <8d158e1f0702031618w2249c64x18ad4d2f03ce3c69@mail.gmail.com>
	 <8d158e1f0702050300s56dd1d9cg76e13b3a13f07de7@mail.gmail.com>
	 <45C73DD8.7070309@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/5/07, Robert Hancock <hancockr@shaw.ca> wrote:
> Patrick Ale wrote:
> The southbridge usually runs the PCI bus connected to the slots, so it's
> possible that PCI bus issues were causing problems..

Explains a lot then yeah... okay, if the error occures again I will
let you know, I am booting up as we speak :)
