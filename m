Return-Path: <linux-kernel-owner+w=401wt.eu-S1754021AbYHWMbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021AbYHWMbT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 08:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752021AbYHWMbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 08:31:07 -0400
Received: from khc.piap.pl ([195.187.100.11]:60613 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751563AbYHWMbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 08:31:06 -0400
To: Jari Aalto <jari.aalto@cante.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.25 DMA: Out of SW-IOMMU space - Asus M2N32 AMD 8GB memory
References: <87od3k2egi.fsf@jondo.cante.net>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sat, 23 Aug 2008 14:31:03 +0200
In-Reply-To: <87od3k2egi.fsf@jondo.cante.net> (Jari Aalto's message of "Sat\, 23 Aug 2008 13\:49\:49 +0300")
Message-ID: <m3vdxrhq0o.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jari Aalto <jari.aalto@cante.net> writes:

>         [1] Aug 21 11:01:19 jondo kernel: [174628.275859] DMA: Out of SW-IOMMU space for 65536 bytes at device 0000:00:0d.0
>         model name      : AMD Athlon(tm) X2 Dual Core Processor
>         BE-2400

grep GART_IOMMU .config
-- 
Krzysztof Halasa
