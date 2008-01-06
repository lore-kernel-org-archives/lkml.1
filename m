Return-Path: <linux-kernel-owner+w=401wt.eu-S1758270AbYAFPTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758270AbYAFPTe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 10:19:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752769AbYAFPT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 10:19:27 -0500
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:2149 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751883AbYAFPT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 10:19:26 -0500
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [PATCH] drivers/dma/ioat_dma.c: inlining failed
Date: Sun, 6 Jan 2008 16:19:22 +0100
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Nelson, Shannon" <shannon.nelson@intel.com>, caglar@pardus.org.tr,
       linux-kernel@vger.kernel.org
References: <200712142144.47310.caglar@pardus.org.tr> <200801061357.24834.m.kozlowski@tuxland.pl> <20080106130351.GF2082@does.not.exist>
In-Reply-To: <20080106130351.GF2082@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801061619.23839.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> The fix is in Linus' tree since 17 Dec 2007, and the line numbers in 
> your error messages also don't make sense in the current tree.

True.

> Is there any problem with your local copy of the tree?

Oh crap ... how could this happen? I'd say it is my git & branches PEBKAC.

Regards,

	Mariusz
