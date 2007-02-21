Return-Path: <linux-kernel-owner+w=401wt.eu-S1422652AbXBUQSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422652AbXBUQSv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 11:18:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422648AbXBUQSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 11:18:51 -0500
Received: from smtp-out-46.synserver.de ([217.119.50.46]:1044 "HELO
	smtp-out-46.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1422654AbXBUQSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 11:18:50 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-ViaOpenRelay-IP: 212.202.34.50
X-SynServer-RBL-IP: 212.202.34.50
X-SynServer-RBL-ReportedBy: dynablock.njabl.org
X-SynServer-RBL-ReportedByCount: *
X-SynServer-RBL-Weights: 100
X-SynServer-RBL-WeightSum: 100
X-SynServer-RBL-WeightStr: **********
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-RemoteDnsName: port-212-202-34-50.dynamic.qsc.de
Date: Wed, 21 Feb 2007 17:18:23 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: "Jean-Luc Coulon (f5ibh)" <jean-luc.coulon@wanadoo.fr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.20-git and 2.6.21-rc1, failed to boot on sata_via
Message-ID: <20070221161823.GA5011@gentoox2.trippelsdorf.de>
References: <1172066520l.8209l.0l@tangerine>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1172066520l.8209l.0l@tangerine>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 21, 2007 at 03:01:54PM +0100, Jean-Luc Coulon (f5ibh) wrote:
>
> At boot time, I've the following messages:
> 
> ACPI: PCI Interrupt 0000:00:0f.0[B] GSI 20(level, low) -> IRQ 20
> sata_via 0000:00:0f.0: failed on iomap PCI BAR 0
> sata_via 0000:00:0f.0: out of memory
> ACPI: PCI interrupt for device 0000:00:0f.0 is disabled
> sata_via: probe of 0000:00:0f.0 failed with error -12

I had the same problem, but the issue is already fixed. See:
http://www.mail-archive.com/linux-ide@vger.kernel.org/msg03945.html

-- 
Markus
