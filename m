Return-Path: <linux-kernel-owner+w=401wt.eu-S932247AbXFRTAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247AbXFRTAk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 15:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765956AbXFRTAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 15:00:13 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:59394 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765885AbXFRTAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 15:00:11 -0400
Date: Mon, 18 Jun 2007 12:00:10 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       suresh.b.siddha@intel.com
Subject: Re: [patch 00/26] Current slab allocator / SLUB patch queue
In-Reply-To: <6bffcb0e0706181158l739864e0t6fb5bc564444f23c@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0706181159430.1896@schroedinger.engr.sgi.com>
References: <20070618095838.238615343@sgi.com>  <46767346.2040108@googlemail.com>
  <Pine.LNX.4.64.0706180936280.4751@schroedinger.engr.sgi.com> 
 <6bffcb0e0706181038j107e2357o89c525261cf671a@mail.gmail.com> 
 <Pine.LNX.4.64.0706181102280.6596@schroedinger.engr.sgi.com>
 <6bffcb0e0706181158l739864e0t6fb5bc564444f23c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jun 2007, Michal Piotrowski wrote:

> Still the same.

Is it still exactly the same strack trace? There could be multiple issue 
if we overflow PAGE_SIZE there.

