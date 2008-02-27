Return-Path: <linux-kernel-owner+w=401wt.eu-S1764796AbYB0HMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764796AbYB0HMt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 02:12:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753632AbYB0HMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 02:12:41 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57187 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841AbYB0HMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 02:12:40 -0500
Date: Wed, 27 Feb 2008 16:10:57 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [RFC][PATCH] page reclaim throttle take2
Cc: kosaki.motohiro@jp.fujitsu.com, Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>
In-Reply-To: <alpine.DEB.1.00.0802262201390.1613@chino.kir.corp.google.com>
References: <47C4F9C0.5010607@linux.vnet.ibm.com> <alpine.DEB.1.00.0802262201390.1613@chino.kir.corp.google.com>
Message-Id: <20080227160746.425E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> Adding yet another sysctl for this functionality seems unnecessary, unless 
> it is attempting to address other VM problems where page reclaim needs to 
> be throttled when it is being stressed.  Those issues need to be addressed 
> directly, in my opinion, instead of attempting to workaround it by 
> limiting the number of concurrent reclaim threads.

hm,

could you post another patch?
I hope avoid implementless discussion.
and I hope compare by benchmark result.


-kosaki

