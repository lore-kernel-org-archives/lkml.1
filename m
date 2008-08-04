Return-Path: <linux-kernel-owner+w=401wt.eu-S1756607AbYHDVyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607AbYHDVyu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 17:54:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765474AbYHDVn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 17:43:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48154 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1771169AbYHDVnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 17:43:55 -0400
Message-ID: <4897780A.20100@linux-foundation.org>
Date: Mon, 04 Aug 2008 16:43:38 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Pekka J Enberg <penberg@cs.helsinki.fi>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org, matthew@wil.cx,
       akpm@linux-foundation.org
Subject: Re: [RFC/PATCH] SLUB: dynamic per-cache MIN_PARTIAL
References: <Pine.LNX.4.64.0808050037400.26319@sbz-30.cs.Helsinki.FI>
In-Reply-To: <Pine.LNX.4.64.0808050037400.26319@sbz-30.cs.Helsinki.FI>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well looks okay. Sigh. I sure wish we would deal with the page allocator
performance instead of adding more buffering.

