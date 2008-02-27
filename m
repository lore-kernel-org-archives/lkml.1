Return-Path: <linux-kernel-owner+w=401wt.eu-S1757611AbYB0NlJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757611AbYB0NlJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 08:41:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753893AbYB0Nk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 08:40:57 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48577 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378AbYB0Nk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 08:40:56 -0500
Subject: Re: [PATCH] sched: don't allow rt_runtime_us to be zero for groups
	having rt tasks
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>,
       Aneesh Kumar KV <aneesh.kumar@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20080227132459.GE15731@linux.vnet.ibm.com>
References: <20080227110829.GA15731@linux.vnet.ibm.com>
	 <1204116417.6242.383.camel@lappy>
	 <20080227132459.GE15731@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Wed, 27 Feb 2008 14:40:37 +0100
Message-Id: <1204119638.6242.404.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-02-27 at 18:54 +0530, Dhaval Giani wrote:

> Well, if it can be done, it shall be done :)

May I suggest: rm -rf /

/me runs

