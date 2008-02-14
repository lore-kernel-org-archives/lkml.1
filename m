Return-Path: <linux-kernel-owner+w=401wt.eu-S1764135AbYBNHTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764135AbYBNHTo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 02:19:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756431AbYBNHTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 02:19:35 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:37774 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756354AbYBNHTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 02:19:34 -0500
Date: Thu, 14 Feb 2008 02:19:08 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] spufs support multiple probes markers
Message-ID: <20080214071908.GA8866@infradead.org>
References: <20080212152245.2d816143.akpm@linux-foundation.org> <20080212233914.GA22966@Krystal> <20080212235650.GA23693@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080212235650.GA23693@Krystal>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 06:56:50PM -0500, Mathieu Desnoyers wrote:
> Update spufs to the new linux kernel markers API, which supports connecting
> more than one probe to a single marker.

Compiles and works for me.  But saying I like the odd API would be lying.

