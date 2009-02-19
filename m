Return-Path: <linux-kernel-owner+w=401wt.eu-S1756285AbZBSNr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285AbZBSNr1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 08:47:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752985AbZBSNrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 08:47:14 -0500
Received: from ti-out-0910.google.com ([209.85.142.191]:49874 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbZBSNrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 08:47:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=s3TE3vF/UpoAqTLnMggTVkv+AdAj/bUDUOW3U2mzoyPHteEs4hOCxPJN1+N0sogal6
         EQJ9VShn2djq5U2pOlkowpEe0HWCDNY9Sb2FvTS18x1rY3ckj6c2sufi1OHflogbsru9
         /4tbno7UCraB/nJnogtK1ZcBoitZBwTyDm4bI=
From: Eric Miao <eric.y.miao@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>
Subject: [PATCH 0/12] ARM: add base support for Marvell PXA168
Date: Thu, 19 Feb 2009 21:45:49 +0800
Message-Id: <1235051161-8858-1-git-send-email-eric.y.miao@gmail.com>
X-Mailer: git-send-email 1.6.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch set adds base support for Marvell's PXA168 application
processor.

Excerpt from Marvell's PXA168 Product Brief:

"""The Marvell® PXA168 processor is the first in a family of application
processors targeted at mass market opportunities in computing and consumer
devices. It balances high computing and multimedia performance with low
power consumption to support extended battery life, and includes a wealth
of integrated peripherals to reduce overall BOM cost ... """

For more information, please see

  http://www.marvell.com/featured/pxa168.jsp

