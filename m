Return-Path: <linux-kernel-owner+w=401wt.eu-S1758994AbXJKVcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758994AbXJKVcd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 17:32:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755784AbXJKVcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 17:32:24 -0400
Received: from [212.12.190.29] ([212.12.190.29]:33921 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754905AbXJKVcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 17:32:23 -0400
From: Al Boldi <a1426z@gawab.com>
To: netfilter-devel@lists.netfilter.org, netdev@vger.kernel.org
Subject: [RFD] iptables:  mangle table obsoletes filter table
Date: Fri, 12 Oct 2007 00:31:42 +0300
User-Agent: KMail/1.5
Cc: linux-net@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200710120031.42805.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

With the existence of the mangle table, how useful is the filter table?

Other than requiring the REJECT target to be ported to the mangle table, is 
the filter table faster than the mangle table?

If not, then shouldn't the filter table be obsoleted to avoid confusion?


Thanks!

--
Al

