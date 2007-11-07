Return-Path: <linux-kernel-owner+w=401wt.eu-S1757979AbXKGIhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757979AbXKGIhm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 03:37:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756700AbXKGIhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 03:37:35 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:38843 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755924AbXKGIhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 03:37:34 -0500
Subject: Re: [patch 00/23] Slab defragmentation V6
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundatin.org, linux-kernel@vger.kernel.org
In-Reply-To: <20071107011130.382244340@sgi.com>
References: <20071107011130.382244340@sgi.com>
Content-Type: text/plain
Date: Wed, 07 Nov 2007 09:37:30 +0100
Message-Id: <1194424650.6289.109.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-11-06 at 17:11 -0800, Christoph Lameter wrote:
> Slab defragmentation

I thought we had agreed that: targeted reclaim, was a more suitable term
for this work as it does not do compaction.


