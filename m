Return-Path: <linux-kernel-owner+w=401wt.eu-S1757278AbZDFJsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278AbZDFJsj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 05:48:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755840AbZDFJop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 05:44:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:42358 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755506AbZDFJoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 05:44:39 -0400
Message-Id: <20090406094458.977814421@chello.nl>
User-Agent: quilt/0.46-1
Date: Mon, 06 Apr 2009 11:44:58 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 00/15] various perf counter bits
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

new features:
  - event limit
  - record time stamps
  - SIGIO support

fixes:
  - mlock accounting
  - swcounter task clock vs NMI readout deadlock
  - comments and such



