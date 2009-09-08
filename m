Return-Path: <linux-kernel-owner+w=401wt.eu-S1752540AbZIHWgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540AbZIHWgs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 18:36:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752505AbZIHWgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 18:36:47 -0400
Received: from fifo99.com ([67.223.236.141]:55672 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752175AbZIHWgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 18:36:47 -0400
Subject: Re: [PATCH 25/23] io-controller: fix queue vs group fairness
From: Daniel Walker <dwalker@fifo99.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       containers@lists.linux-foundation.org, dm-devel@redhat.com,
       nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com,
       torvalds@linux-foundation.org, mingo@elte.hu, riel@redhat.com
In-Reply-To: <20090908222827.GC3558@redhat.com>
References: <1251495072-7780-1-git-send-email-vgoyal@redhat.com>
	 <20090908222827.GC3558@redhat.com>
Content-Type: text/plain
Date: Tue, 08 Sep 2009 15:37:07 -0700
Message-Id: <1252449427.14793.36.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


patches 25, and 26 both have checkpatch errors.. Could you run them
through checkpatch and clean up any errors you find?

Daniel

