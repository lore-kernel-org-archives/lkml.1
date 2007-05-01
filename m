Return-Path: <linux-kernel-owner+w=401wt.eu-S1945918AbXEAUqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945918AbXEAUqe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 16:46:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946003AbXEAUqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 16:46:33 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:55026 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1946002AbXEAUq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 16:46:28 -0400
Date: Tue, 1 May 2007 13:46:26 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Hugh Dickins <hugh@veritas.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: 2.6.22 -mm merge plans: slub
In-Reply-To: <20070501133618.93793687.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0705011345360.26494@schroedinger.engr.sgi.com>
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705011846590.10660@blonde.wat.veritas.com>
 <20070501125559.9ab42896.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705012101410.26170@blonde.wat.veritas.com>
 <20070501133618.93793687.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 May 2007, Andrew Morton wrote:

> otoh I could do some frantic patch mangling and make it easier to carry
> slub out-of-tree, but do we gain much from that?

Then we may loose all the slab API cleanups? Yuck. I really do not want 
redo those....

