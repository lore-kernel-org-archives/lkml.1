Return-Path: <linux-kernel-owner+w=401wt.eu-S1755738AbZFPWIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755738AbZFPWIi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 18:08:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753800AbZFPWIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 18:08:31 -0400
Received: from ixro-out-rtc.ixiacom.com ([92.87.192.98]:13919 "EHLO
	ixro-ex1.ixiacom.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751505AbZFPWIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 18:08:30 -0400
X-Greylist: delayed 913 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Jun 2009 18:08:30 EDT
Date: Wed, 17 Jun 2009 00:53:18 +0300
From: Dragos Tatulea <dtatulea@ixiacom.com>
To: linux-kernel@vger.kernel.org
Subject: DMA_ENGINE: can't use it without selecting a dma engine driver
Message-ID: <20090617005318.1e35ae98@dragos-tp.localdomain>
Organization: IXIA
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jun 2009 21:53:18.0376 (UTC) FILETIME=[DBB7BA80:01C9EECC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

	Just discovered that it's impossible to select the dma engine without
	compiling a dma engine driver from the kernel. What if I want to use a
	different dma engine?
 
	I'm using CONFIG_DMADEVICES=y CONFIG_DMA_ENGINE=y (dependencies
	included),	

Thanks,
Dragos
