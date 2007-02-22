Return-Path: <linux-kernel-owner+w=401wt.eu-S1751648AbXBVP0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751648AbXBVP0j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 10:26:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751651AbXBVP0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 10:26:39 -0500
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:35383 "EHLO
	netops-testserver-4.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751648AbXBVP0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 10:26:38 -0500
Date: Thu, 22 Feb 2007 07:26:37 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: David Miller <davem@davemloft.net>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: SLUB: The unqueued Slab allocator
In-Reply-To: <20070222.005824.34601725.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0702220726010.858@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0702212250271.30485@schroedinger.engr.sgi.com>
 <20070222.005824.34601725.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

n Thu, 22 Feb 2007, David Miller wrote:

> All of that logic needs to be protected by CONFIG_ZONE_DMA too.

Right. Will fix that in the next release.

