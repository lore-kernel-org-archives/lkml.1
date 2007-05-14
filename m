Return-Path: <linux-kernel-owner+w=401wt.eu-S1761994AbXENCO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761994AbXENCO0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 22:14:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754368AbXENCOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 22:14:19 -0400
Received: from mail33.syd.optusnet.com.au ([211.29.132.104]:41051 "EHLO
	mail33.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753215AbXENCOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 22:14:19 -0400
From: Con Kolivas <kernel@kolivas.org>
To: linux-kernel@vger.kernel.org, ck@vds.kolivas.org
Subject: Standalone swap prefetch patch for mainline
Date: Mon, 14 May 2007 12:10:43 +1000
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705141210.43614.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've had a few requests for a standalone patch implementing swap prefetch for 
mainline.

Here is a patch that is a current rollup that should apply and work for 
vanilla 2.6.21 (ie not a -ck kernel):

http://ck.kolivas.org/patches/swap-prefetch/2.6.21-swap_prefetch-38.patch

-- 
-ck
