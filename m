Return-Path: <linux-kernel-owner+w=401wt.eu-S964796AbXH0Tfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964796AbXH0Tfr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 15:35:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758215AbXH0Tfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 15:35:34 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:35657 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760071AbXH0Tfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 15:35:33 -0400
Date: Mon, 27 Aug 2007 12:35:33 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 00/28] Add cmpxchg64_local and cmpxchg_local to each
 architecture
In-Reply-To: <20070827155234.062715780@polymtl.ca>
Message-ID: <Pine.LNX.4.64.0708271234580.5026@schroedinger.engr.sgi.com>
References: <20070827155234.062715780@polymtl.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Aug 2007, Mathieu Desnoyers wrote:

> Here is the patch series for 2.6.23-rc3-mm1 that adds cmpxchg_local, and now
> also cmpxchg64_local, to each architecture.

Any planned uses of cmpxchg64_local? 
