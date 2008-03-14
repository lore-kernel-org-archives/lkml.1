Return-Path: <linux-kernel-owner+w=401wt.eu-S1756351AbYCNNSa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756351AbYCNNSa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 09:18:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752238AbYCNNSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 09:18:23 -0400
Received: from verein.lst.de ([213.95.11.210]:40373 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751858AbYCNNSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 09:18:22 -0400
Date: Fri, 14 Mar 2008 14:17:09 +0100
From: Christoph Hellwig <hch@lst.de>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, hch@lst.de,
       Marc Dionne <marc.c.dionne@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] struct export_operations: adjust comments to match current members
Message-ID: <20080314131709.GA9818@lst.de>
References: <22062.1205500289@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22062.1205500289@redhat.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2008 at 01:11:29PM +0000, David Howells wrote:
> 
> From: "Marc Dionne" <marc.c.dionne@gmail.com>
> 
> The comments in the definition of struct export_operations don't match the
> current members.
> 
> Add a comment for the 2 new functions and remove 2 comments for unused ones.
> 
> Signed-off-by: Marc Dionne <marc.c.dionne@gmail.com>
> Acked-by: David Howells <dhowells@redhat.com>

ACK.

