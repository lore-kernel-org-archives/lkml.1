Return-Path: <linux-kernel-owner+w=401wt.eu-S1756045AbYAVGOF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045AbYAVGOF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 01:14:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751406AbYAVGNx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 01:13:53 -0500
Received: from hs-out-0708.google.com ([64.233.178.248]:38019 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751034AbYAVGNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 01:13:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ib+I5ZtNaOET6pTfvFnFAY7gmB0w3s1jQ52rnbpcDCXw3KpHdYqBimaR6ZcRX3Kk6dmRCW6qqS9yyFedAicVJojL04BKpXv5FW+EW979L6xC3PsIm44EBNKtfZfFGngbfCX7PWd0hQWVMDI9BlyRpo2v2TrXvt4/LlJfznAVr7Q=
Message-ID: <a8e1da0801212213v4d3a7d9ar21eda06d57d4d508@mail.gmail.com>
Date: Tue, 22 Jan 2008 14:13:51 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: [PATCH 7/7] driver-core : convert semaphore to mutex in struct class
Cc: "Jarek Poplawski" <jarkao2@gmail.com>,
       "Kay Sievers" <kay.sievers@vrfy.org>,
       "Alan Stern" <stern@rowland.harvard.edu>, stefanr@s5r6.in-berlin.de,
       "David Brownell" <david-b@pacbell.net>,
       "Kernel development list" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080122051505.GA7619@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a8e1da0801210044t5f705f77n8e310878775f7b5b@mail.gmail.com>
	 <20080121211625.GA2758@ami.dom.local>
	 <a8e1da0801211655y5a7313edn331ad4312b0b7de9@mail.gmail.com>
	 <20080122051505.GA7619@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >
> > Hope the iteration patches 1-6/7 could be applied.
>
> Can you resend them again, and CC: me on all of them, with the latest
> updates, so I know what I should be reviewing this time around?

Hi, sent.

>
> thanks,
>
> greg k-h
>
