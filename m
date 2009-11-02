Return-Path: <linux-kernel-owner+w=401wt.eu-S1755349AbZKBRRB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349AbZKBRRB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 12:17:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753076AbZKBRRB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 12:17:01 -0500
Received: from smtp2.ultrahosting.com ([74.213.174.253]:53824 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751042AbZKBRRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 12:17:00 -0500
Date: Mon, 2 Nov 2009 12:09:45 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@V090114053VZO-1
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       aarcange@redhat.com, akpm@linux-foundation.org, minchan.kim@gmail.com,
       rientjes@google.com, vedran.furac@gmail.com,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>
Subject: Re: [RFC][-mm][PATCH 3/6] oom-killer: count lowmem rss
In-Reply-To: <20091102162617.9d07e05f.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.1.10.0911021209180.2028@V090114053VZO-1>
References: <20091102162244.9425e49b.kamezawa.hiroyu@jp.fujitsu.com> <20091102162617.9d07e05f.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I dont think this patch will work in !NUMA but its useful there too. Can
you make this work in general?


