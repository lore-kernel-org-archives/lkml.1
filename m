Return-Path: <linux-kernel-owner+w=401wt.eu-S1761386AbXIXRu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761386AbXIXRu5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 13:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758045AbXIXRut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 13:50:49 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48229 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755631AbXIXRus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 13:50:48 -0400
Date: Mon, 24 Sep 2007 18:50:44 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [patch 6/7] Linux Kernel Markers - Documentation
Message-ID: <20070924175044.GD1608@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	"Frank Ch. Eigler" <fche@redhat.com>
References: <20070924164950.006047409@polymtl.ca> <20070924165428.335030720@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070924165428.335030720@polymtl.ca>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2007 at 12:49:56PM -0400, Mathieu Desnoyers wrote:
> Here is some documentation explaining what is/how to use the Linux
> Kernel Markers.

As mentioned in the tracing infrastructure thread I don't think
putting code into Documentation is a good idea.  Either of you really
should start a sample/ toplevel directory for this kind of stuff
including a Kconfig menu etc to be able to build these samples as
part of an allmodconfig.

