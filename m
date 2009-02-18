Return-Path: <linux-kernel-owner+w=401wt.eu-S1755562AbZBRUbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562AbZBRUbX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 15:31:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752787AbZBRUbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 15:31:15 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:46473 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525AbZBRUbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 15:31:14 -0500
Date: Wed, 18 Feb 2009 15:30:53 -0500
From: Kyle McMartin <kyle@infradead.org>
To: Jason Baron <jbaron@redhat.com>
Cc: mingo@elte.hu, rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       acme@ghostprotocols.net, fweisbec@gmail.com, fche@redhat.com,
       peterz@infradead.org, compudj@krystal.dyndns.org
Subject: Re: [PATCH] new irq tracer
Message-ID: <20090218203053.GA17272@bombadil.infradead.org>
References: <20090218195328.GA3112@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090218195328.GA3112@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 18, 2009 at 02:53:28PM -0500, Jason Baron wrote:
> hi,
> 
> I think this patch is useful in understanding irq system behavior, and
> for tracking down irq driver handlers that are firing too often or
> spending too much time handling an irq. This approach could be extended
> to the timer irq and for softirqs...
> 

Very cool, I had written something similar a week or two ago to debug
something but never had gotten around to posting it. :)

Looks like it works just as well too. Glad to see it.

cheers, Kyle
