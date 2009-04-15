Return-Path: <linux-kernel-owner+w=401wt.eu-S1751673AbZDOEOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673AbZDOEOu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 00:14:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751014AbZDOEOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 00:14:41 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46012 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbZDOEOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 00:14:41 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: [RFC][PATCH] Add file RSS accounting to the memory resource controller
Cc: kosaki.motohiro@jp.fujitsu.com, "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090414180706.GQ7082@balbir.in.ibm.com>
References: <20090414180706.GQ7082@balbir.in.ibm.com>
Message-Id: <20090415131348.AC43.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Wed, 15 Apr 2009 13:14:37 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> We currently don't track file RSS, the RSS we report is actually anon RSS.
> All the file mapped pages, come in through the page cache and get accounted
> there. This patch adds support for accounting file RSS pages. It should
> 
> 1. Help improve the metrics reported by the memory resource controller
> 2. Will form the basis for a future shared memory accounting heuristic
>    that has been proposed by Kamezawa.

It seems impressive feature although I haven't review it.
I'll review this later.

thanks.


