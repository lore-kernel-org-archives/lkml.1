Return-Path: <linux-kernel-owner+w=401wt.eu-S1759138AbXEJG6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759138AbXEJG6P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 02:58:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755811AbXEJG6C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 02:58:02 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34756 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068AbXEJG6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 02:58:00 -0400
Date: Thu, 10 May 2007 07:57:55 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, hch@infradead.org,
       Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [patch 04/10] Linux Kernel Markers - PowerPC optimized version
Message-ID: <20070510065755.GD8019@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	Paul Mackerras <paulus@samba.org>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>
References: <20070510015555.973107048@polymtl.ca> <20070510020916.196492766@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070510020916.196492766@polymtl.ca>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2007 at 09:55:59PM -0400, Mathieu Desnoyers wrote:
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Can we please get the non-optimized ones in first and then do the
optimized incremental ontop of that?

