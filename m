Return-Path: <linux-kernel-owner+w=401wt.eu-S1753382AbZGKQIM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382AbZGKQIM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 12:08:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751576AbZGKQH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 12:07:59 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:44464 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbZGKQH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 12:07:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=i6+wiX+7lreTExPJcQMKxPMQLY4cEXdimwL86QtPGb382zUHEW8xGapsgmSeR0DLOV
         eqBXckL5XctkWd4rALkbsg0aAtBFY6vLq5bmT03JckRECkkRUVJ1/L1Bc/k/IAdHDLFR
         QzF1rfQZyeH/UMd6311pKJsIt18fSiSpiyCQA=
From: tom.leiming@gmail.com
To: linux@arm.linux.org.uk, joerg.roedel@amd.com
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH 0/3] ARM:dma-mapping:Support DMA-API debugging facility on ARM
Date: Sun, 12 Jul 2009 00:07:44 +0800
Message-Id: <1247328467-24985-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.6.0.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
This patch set introduces dma-api debugging facility on ARM, and is
against -rc2-next tree.


