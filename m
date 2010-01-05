Return-Path: <linux-kernel-owner+w=401wt.eu-S1754708Ab0AEPXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708Ab0AEPXR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 10:23:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754614Ab0AEPXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 10:23:16 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:38282 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497Ab0AEPXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 10:23:15 -0500
Date: Tue, 5 Jan 2010 09:22:11 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [this_cpu_xx V9 5/7] this_cpu_ops: page allocator conversion
In-Reply-To: <4B42DCF7.9040609@kernel.org>
Message-ID: <alpine.DEB.2.00.1001050921520.1074@router.home>
References: <20100104223439.228028923@quilx.com> <20100104223556.613041583@quilx.com> <4B42DCF7.9040609@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jan 2010, Tejun Heo wrote:

> The above chunk causes build failure due to removed ret used later on
> return statement.  Changed it to return NOTIFY_OK.

Thats a change in -next? Patch was against upstream.

