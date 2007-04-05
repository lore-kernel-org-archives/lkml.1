Return-Path: <linux-kernel-owner+w=401wt.eu-S1767391AbXDEWpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767391AbXDEWpj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 18:45:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767382AbXDEWpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 18:45:38 -0400
Received: from smtp.osdl.org ([65.172.181.24]:56162 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767391AbXDEWph (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 18:45:37 -0400
Date: Thu, 5 Apr 2007 15:44:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: root@programming.kicks-ass.net
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, miklos@szeredi.hu,
       neilb@suse.de, dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com,
       a.p.zijlstra@chello.nl, nikita@clusterfs.com
Subject: Re: [PATCH 09/12] mm: remove throttle_vm_writeback
Message-Id: <20070405154440.0f42fa9f.akpm@linux-foundation.org>
In-Reply-To: <20070405174319.860268120@programming.kicks-ass.net>
References: <20070405174209.498059336@programming.kicks-ass.net>
	<20070405174319.860268120@programming.kicks-ass.net>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 05 Apr 2007 19:42:18 +0200
root@programming.kicks-ass.net wrote:

> rely on accurate dirty page accounting to provide enough push back

I think we'd like to see a bit more justification than that, please.
