Return-Path: <linux-kernel-owner+w=401wt.eu-S1764986AbYAaElu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764986AbYAaElu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 23:41:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbYAaElj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 23:41:39 -0500
Received: from gate.crashing.org ([63.228.1.57]:50207 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759202AbYAaElj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 23:41:39 -0500
Message-Id: <D5CED6F1-A708-4866-BA3D-75F3CCBA43F6@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: spi-devel-general@lists.sourceforge.net
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v915)
Subject: SPI related Kconfig warning
Date: Wed, 30 Jan 2008 22:41:33 -0600
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
X-Mailer: Apple Mail (2.915)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Was wondering if anyone was looking at the cause of this warning in  
top of linus's tree (8af03e782cae1e0a0f530ddd22301cdd12cf9dc0)

drivers/spi/Kconfig:156:warning: 'select' used by config symbol  
'SPI_PXA2XX' refers to undefined symbol 'PXA_SSP'

I was doing a build of a ppc kernel.

- k
