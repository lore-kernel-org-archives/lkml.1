Return-Path: <linux-kernel-owner+w=401wt.eu-S932825AbZGPRP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932825AbZGPRP3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 13:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932748AbZGPRP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 13:15:29 -0400
Received: from cmpxchg.org ([85.214.51.133]:36861 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932617AbZGPRP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 13:15:29 -0400
Date: Thu, 16 Jul 2009 19:14:31 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/5]  move ClearPageActive from move_active_pages() to shrink_active_list()
Message-ID: <20090716171431.GA2267@cmpxchg.org>
References: <20090716173449.9D4B.A69D9226@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090716173449.9D4B.A69D9226@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 16, 2009 at 05:37:34PM +0900, KOSAKI Motohiro wrote:
> This patch series are several vmscan cleanups.

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
