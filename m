Return-Path: <linux-kernel-owner+w=401wt.eu-S1754363AbZAIQzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363AbZAIQzc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 11:55:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752467AbZAIQzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 11:55:19 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:49464 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324AbZAIQzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 11:55:17 -0500
Date: Fri, 9 Jan 2009 08:55:08 -0800
From: Dirk Hohndel <hohndel@infradead.org>
To: "Zhao, Yu" <yu.zhao@intel.com>
Cc: "Han, Weidong" <weidong.han@intel.com>,
       "'Grant Grundler'" <grundler@parisc-linux.org>,
       "'linux-pci@vger.kernel.org'" <linux-pci@vger.kernel.org>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "'Jesse Barnes'" <jbarnes@virtuousgeek.org>,
       "'iommu@lists.linux-foundation.org'" 
	<iommu@lists.linux-foundation.org>,
       "'Ingo Molnar'" <mingo@elte.hu>,
       "'Arjan van de Ven'" <arjan@infradead.org>
Subject: Re: git-latest: kernel oops in IOMMU setup
Message-ID: <20090109085508.5d765704@infradead.org>
In-Reply-To: <49677F2B.9000508@intel.com>
References: <20090108120538.0176d348@infradead.org>
	<20090108214116.GB20506@colo.lackof.org>
	<715D42877B251141A38726ABF5CABF2C018E8FEA77@pdsmsx503.ccr.corp.intel.com>
	<20090108180515.2f279671@infradead.org>
	<20090108205222.2c89dcde@infradead.org>
	<715D42877B251141A38726ABF5CABF2C018E8FECAA@pdsmsx503.ccr.corp.intel.com>
	<20090109070805.525c0de9@infradead.org>
	<49677856.90807@intel.com>
	<20090109083435.2ac20fd5@infradead.org>
	<49677F2B.9000508@intel.com>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hohndel@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Jan 2009 00:45:31 +0800
"Zhao, Yu" <yu.zhao@intel.com> wrote:
> > Yes,
> > 
> > DMAR: Device scope device [0000:00:03:02] not found
> > DMAR: Device scope device [0000:00:03:02] not found
> > DMAR: Device scope device [0000:00:03:03] not found
> > DMAR: Device scope device [0000:00:03:03] not found
> 
> The laptop has a nasty bios, try to update it if you want to get rid
> of these noises... assuming you are luck enough :-)

It's a Lenovo Thinkpad X200s - and I am running the latest BIOS (at
least according to their support website) :-(

 kernel: thinkpad_acpi: ThinkPad ACPI Extras v0.21
 kernel: thinkpad_acpi: http://ibm-acpi.sf.net/
 kernel: thinkpad_acpi: ThinkPad BIOS 6DET33WW (1.10 ), EC 7XHT21WW-1.03
 kernel: thinkpad_acpi: Lenovo ThinkPad X200s, model 7465CTO

/D

-- 
Dirk Hohndel
Intel Open Source Technology Center
