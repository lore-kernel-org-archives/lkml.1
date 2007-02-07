Return-Path: <linux-kernel-owner+w=401wt.eu-S1030297AbXBGETL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030297AbXBGETL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 23:19:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965642AbXBGETL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 23:19:11 -0500
Received: from an-out-0708.google.com ([209.85.132.247]:22408 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965634AbXBGETK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 23:19:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Z+bdvkn+IvRQFQKgzLAg84KakfxoDgaVgdFA1s/dDqFltU/YSgvVjMejPGtJTFrAysXwd7q9xEW9CPdM1y8F3bnm7tZkl0VSeV0JnyKK6U67meuesmQrpi+sSTmW7vKX4Ay/8y7mzfRC2cAvOWvZnGoH7E7CWCaF32Jg4/RxEg8=
Message-ID: <3877989d0702062019w5e57471di540404b60f7bdd43@mail.gmail.com>
Date: Wed, 7 Feb 2007 12:19:09 +0800
From: "Luming Yu" <luming.yu@gmail.com>
To: "Manu Abraham" <abraham.manu@gmail.com>
Subject: Re: 2.6.20 PCI Cannot allocate resource region 2
Cc: "Grant Grundler" <grundler@parisc-linux.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       greg@kroah.com
In-Reply-To: <1a297b360702060424m393d66cdka4a446b24cbd1ff@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1a297b360702041709l3b0309c7y8fcd33df1d487889@mail.gmail.com>
	 <20070206045528.GA4228@colo.lackof.org>
	 <20070206050331.GB4228@colo.lackof.org>
	 <20070205213339.80239a22.akpm@linux-foundation.org>
	 <20070206084638.GB20752@colo.lackof.org>
	 <1a297b360702060106x321bfb8dw918d15df76952576@mail.gmail.com>
	 <1a297b360702060129n54f73e66qc753a2ccb35cb3cd@mail.gmail.com>
	 <3877989d0702060421g1a00c114yba9e193db55f3d11@mail.gmail.com>
	 <1a297b360702060424m393d66cdka4a446b24cbd1ff@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> none on the card, a flash or a firmware .. it has a 24c02 EEPROM for
> vendor information, that's all

Ok, sounds like windows driver can fix the broken EEPROM  on you card.
Otherwise, I can not explain how windows driver can fix the problem for linux.
Anyway, this issue is NOT linux problem. right?
