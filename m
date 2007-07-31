Return-Path: <linux-kernel-owner+w=401wt.eu-S1764910AbXGaVFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764910AbXGaVFh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 17:05:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754024AbXGaVF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 17:05:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38158
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752607AbXGaVF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 17:05:27 -0400
Date: Tue, 31 Jul 2007 14:05:18 -0700 (PDT)
Message-Id: <20070731.140518.27952164.davem@davemloft.net>
To: m.kozlowski@tuxland.pl
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 04] drivers/sbus/char/bbc_i2c.c: kmalloc + memset
 conversion to kzalloc
From: David Miller <davem@davemloft.net>
In-Reply-To: <200707311858.05485.m.kozlowski@tuxland.pl>
References: <200707311845.48807.m.kozlowski@tuxland.pl>
	<200707311858.05485.m.kozlowski@tuxland.pl>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Date: Tue, 31 Jul 2007 18:58:05 +0200

> Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

Patch applied, thanks.
