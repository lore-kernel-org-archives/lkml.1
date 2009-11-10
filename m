Return-Path: <linux-kernel-owner+w=401wt.eu-S1758690AbZKJXW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758690AbZKJXW3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 18:22:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758635AbZKJXW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 18:22:28 -0500
Received: from smtp.ultrahosting.com ([74.213.174.254]:49581 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758647AbZKJXW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 18:22:28 -0500
Date: Tue, 10 Nov 2009 18:20:33 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@V090114053VZO-1
To: Andrew Morton <akpm@linux-foundation.org>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Dave Jones <davej@redhat.com>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>
Subject: Re: [MM] Make mm counters per cpu instead of atomic V2
In-Reply-To: <20091110144438.dbab0ba8.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0911101820030.28336@V090114053VZO-1>
References: <alpine.DEB.1.10.0911041409020.7409@V090114053VZO-1> <20091104234923.GA25306@redhat.com> <alpine.DEB.1.10.0911051004360.25718@V090114053VZO-1> <alpine.DEB.1.10.0911051035100.25718@V090114053VZO-1> <20091106101106.8115e0f1.kamezawa.hiroyu@jp.fujitsu.com>
 <20091110144438.dbab0ba8.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Nov 2009, Andrew Morton wrote:

> Adding a thousand cache misses to the timer interrupt is the sort of
> thing which makes people unhappy?

Obviously I was hoping for new ideas instead of just restatements of the
problem.

