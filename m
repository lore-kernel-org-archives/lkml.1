Return-Path: <linux-kernel-owner+w=401wt.eu-S1754178AbYAMAOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178AbYAMAOc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 19:14:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751658AbYAMAO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 19:14:26 -0500
Received: from py-out-1112.google.com ([64.233.166.177]:54751 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbYAMAOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 19:14:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=o5YQysFNaRxu28WBD524CmWhEIuvv6B2zfppSoW0tIYj317DsKTlj9AUcTkQ4mMbumknKjI3ilIean3X8G1fBCj5FddTqae6epkO6//2mgzCEBoCOOs1MwRKF6haqsu+aCF3sEQ4syLBLWgUnpweEJOOv3mYAnx14XPTOoS0x/c=
Message-ID: <bc64b4640801121614l6da4071h90983808edd97f75@mail.gmail.com>
Date: Sun, 13 Jan 2008 03:14:23 +0300
From: Dmitry <dbaryshkov@gmail.com>
To: cbouatmailru@gmail.com
Subject: Re: [PATCH] pda_power: add device_init_wakeup
Cc: linux-kernel@vger.kernel.org, cbou@mail.ru, dwmw2@infradead.org
In-Reply-To: <20080112235211.GA12105@zarina>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080109163952.GA29397@doriath.ww600.siemens.net>
	 <20080112225016.GA24957@doriath.ww600.siemens.net>
	 <20080112235211.GA12105@zarina>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2008/1/13, Anton Vorontsov <cbouatmailru@gmail.com>:
> On Sun, Jan 13, 2008 at 01:50:16AM +0300, Dmitry Baryshkov wrote:
> > Hi,
> >
> > Please apply this patch. Otherwise pda_power can't generate wakeup
> > events. I forgot this in the initial pda_power suspend/resume patch.
> >
> > Add device_init_wakeup to init wakeup.
>
> Thanks, folded into "pda_power: add suspend/resume support" patch.
>
> FYI, I got it first time, just didn't have time to process. ;-)


Thank you :) Sorry for pinging you too fast.

-- 
With best wishes
Dmitry
