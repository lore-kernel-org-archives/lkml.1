Return-Path: <linux-kernel-owner+w=401wt.eu-S1752712AbXBJFxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712AbXBJFxY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 00:53:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752713AbXBJFxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 00:53:24 -0500
Received: from smtp-out-45.synserver.de ([217.119.50.45]:60079 "HELO
	smtp-out-45.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752712AbXBJFxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 00:53:23 -0500
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
Date: Sat, 10 Feb 2007 06:46:29 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata updates 1 of 3
Message-ID: <20070210054629.GA4395@gentoox2.trippelsdorf.de>
References: <20070210010914.GA19717@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070210010914.GA19717@havoc.gtf.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This update breaks sata_via on my VIA K8T800Pro machine:
 
 sata_via 0000:00:0f.0 : failed to iomap PCI BAR 0
 sata_via 0000:00:0f.0 : out of memory
 sata_via probe of 0000:00:0f.0 failed with error -12
-- 
Markus
