Return-Path: <linux-kernel-owner+w=401wt.eu-S1757045AbYKTSQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757045AbYKTSQj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 13:16:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756346AbYKTSQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 13:16:04 -0500
Received: from nlpi025.sbcis.sbc.com ([207.115.36.54]:41229 "EHLO
	nlpi025.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756695AbYKTSQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 13:16:03 -0500
Date: Thu, 20 Nov 2008 12:15:19 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: mm: slab - __cache_alloc NULL prefetch fix
In-Reply-To: <20081120164400.GC7363@localhost>
Message-ID: <Pine.LNX.4.64.0811201215000.23154@quilx.com>
References: <20081120164400.GC7363@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Nov 2008, Cyrill Gorcunov wrote:

> Do not prefetch NULL

Why not? Does it matter?

