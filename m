Return-Path: <linux-kernel-owner+w=401wt.eu-S1752544AbZHTTJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544AbZHTTJq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 15:09:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752071AbZHTTJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 15:09:45 -0400
Received: from e28smtp09.in.ibm.com ([59.145.155.9]:49147 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686AbZHTTJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 15:09:45 -0400
Date: Fri, 21 Aug 2009 00:39:42 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, prarit@redhat.com,
       andi.kleen@intel.com, KOSAKI Motohiro <m-kosaki@ceres.dti.ne.jp>,
       Daisuke Miyakawa <dmiyakawa@google.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Scalability fixes -- 2.6.31 candidate?
Message-ID: <20090820190941.GA29572@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Andrew,

I've been wondering if the scalability fixes for root overhead in
memory cgroup is a candidate for 2.6.31? They don't change
functionality but help immensely using existing accounting features.

Opening up the email for more debate and discussion and thoughts.

-- 
	Balbir
