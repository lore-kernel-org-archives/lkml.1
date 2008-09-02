Return-Path: <linux-kernel-owner+w=401wt.eu-S1754014AbYIBJYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014AbYIBJYg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 05:24:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751465AbYIBJY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 05:24:27 -0400
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:37641 "EHLO
	e28esmtp04.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751101AbYIBJY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 05:24:26 -0400
Message-ID: <48BD0641.4040705@linux.vnet.ibm.com>
Date: Tue, 02 Sep 2008 14:54:17 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, hugh@veritas.com,
       menage@google.com, xemul@openvz.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [RFC][PATCH] Remove cgroup member from struct page
References: <20080831174756.GA25790@balbir.in.ibm.com> <200809011656.45190.nickpiggin@yahoo.com.au> <20080901161927.a1fe5afc.kamezawa.hiroyu@jp.fujitsu.com> <200809011743.42658.nickpiggin@yahoo.com.au>
In-Reply-To: <200809011743.42658.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> That could be a reasonable solution.  Balbir has other concerns about
> this... so I think it is OK to try the radix tree approach first.

Thanks, Nick!

Kamezawa-San, I would like to integrate the radix tree patches after review and
some more testing then integrate your patchset on top of it. Do you have any
objections/concerns with the suggested approach?

-- 
	Balbir
