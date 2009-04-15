Return-Path: <linux-kernel-owner+w=401wt.eu-S1758926AbZDOI0B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758926AbZDOI0B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 04:26:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758873AbZDOIZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 04:25:29 -0400
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:40235 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758695AbZDOIZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 04:25:27 -0400
Date: Wed, 15 Apr 2009 13:54:46 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Dan Malek <dan@embeddedalley.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Paul Menage <menage@google.com>
Subject: Re: [PATCH] Memory usage limit notification addition to memcg
Message-ID: <20090415082446.GT7082@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <1239660512-25468-1-git-send-email-dan@embeddedalley.com> <20090415093555.d84b6655.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090415093555.d84b6655.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-04-15 09:35:55]:

> On Mon, 13 Apr 2009 18:08:32 -0400
> Dan Malek <dan@embeddedalley.com> wrote:
> 
> > This patch updates the Memory Controller cgroup to add
> > a configurable memory usage limit notification.  The feature
> > was presented at the April 2009 Embedded Linux Conference.
> > 
> > Signed-off-by: Dan Malek <dan@embeddedalley.com>
> 
> Welcome to memory cgroup world :)

Welcome! I've taken a cursory look at the patches, but I'll come back
with more review comments. Could you point me to your
presentation/paper? I could not find the PDF at
http://www.celinuxforum.org/CelfPubWiki/ELC2009Presentations
-- 
	Balbir
