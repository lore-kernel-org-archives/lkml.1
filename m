Return-Path: <linux-kernel-owner+w=401wt.eu-S932552AbZFQJim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932552AbZFQJim (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 05:38:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755498AbZFQJie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 05:38:34 -0400
Received: from mga11.intel.com ([192.55.52.93]:50556 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755016AbZFQJie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 05:38:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,235,1243839600"; 
   d="scan'208";a="467148055"
Subject: mce test coverage data for x86.git/mce3
From: Huang Ying <ying.huang@intel.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@linux.intel.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 17 Jun 2009 17:38:35 +0800
Message-Id: <1245231515.11965.152.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, All,

We are testing latest kernel MCE code with an injection tool named
mce-inject (git://git.kernel.org/pub/scm/utils/cpu/mce/mce-inject.git)
and a test suite named mce-test
(git://git.kernel.org/pub/scm/utils/cpu/mce/mce-test.git). 

The test coverage data gotten with kernel gcov support and a self made
mce-severity coverage tool is uploaded to:

http://ftp.kernel.org/pub/linux/kernel/people/yhuang/mce-coverage

We will continue to test latest kernel MCE code.

Best Regards,
Huang Ying


