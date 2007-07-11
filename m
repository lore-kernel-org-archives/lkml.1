Return-Path: <linux-kernel-owner+w=401wt.eu-S1762145AbXGKJlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762145AbXGKJlA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 05:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761274AbXGKJkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 05:40:46 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56947 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761135AbXGKJko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 05:40:44 -0400
Date: Wed, 11 Jul 2007 10:40:34 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Greg KH <greg@kroah.com>, rientjes@google.com,
       Christoph Lameter <clameter@sgi.com>,
       Christoph Hellwig <hch@infradead.org>,
       David Miller <davem@davemloft.net>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org
Subject: Re: [PATCH 0/5] more about numa_node with struct device
Message-ID: <20070711094034.GC19061@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Yinghai Lu <Yinghai.Lu@Sun.COM>,
	Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
	Greg KH <greg@kroah.com>, rientjes@google.com,
	Christoph Lameter <clameter@sgi.com>,
	David Miller <davem@davemloft.net>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	netdev@vger.kernel.org
References: <200707101652.20613.yinghai.lu@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707101652.20613.yinghai.lu@sun.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2007 at 04:52:19PM -0700, Yinghai Lu wrote:
> these are revised or new patch with numa_node in struct device in addition to 

Do you have a pointer to a background posting why you want all this?
