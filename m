Return-Path: <linux-kernel-owner+w=401wt.eu-S1759525AbXGCH2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759525AbXGCH2W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 03:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758990AbXGCH2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 03:28:05 -0400
Received: from wx-out-0506.google.com ([66.249.82.238]:49557 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758777AbXGCH2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 03:28:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=j31bI+r1cz4YKBhBxaleiSI4xNAufiQdxSpWzG87Q1PHi23+fvMGJyLYp34Mef5OmJ/PabjaMyKQ74IvsrPbVAhr+faoK4kDj40J84m6S1VRvbMvmrBPOxV1DO1YxoTd6vDNF+/3lRv2OMbQQTMA8191ljgWCc4EfTW+kMaiabA=
Message-ID: <4dde4acb0707030028p2c078a22jd537853f145c2518@mail.gmail.com>
Date: Tue, 3 Jul 2007 12:58:03 +0530
From: "Midhun Agnihotram" <agnimidhun@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: platform_driver_register() ??
Cc: "Pierre Ossman" <drzeus-mmc@drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

  I have an MMC driver for my kit (i.MX21 based cogent board
CSB535FS), which is supplied by Cogent (Kernel version 2.6.16).

   The original driver (linux/drivers/mmc/mmc_block.c) uses
mmc_register_driver() method to register the driver but the one
supplied by Cogent uses platform_driver_register() method. What is the
difference between the two?


Thanks,
Midhun.
