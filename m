Return-Path: <linux-kernel-owner+w=401wt.eu-S1757879AbYGNQbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757879AbYGNQbt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 12:31:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756523AbYGNQbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 12:31:14 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52169 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756277AbYGNQbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 12:31:13 -0400
Date: Mon, 14 Jul 2008 11:31:07 -0500
From: Jack Steiner <steiner@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] - GRU virtual -> physical translation
Message-ID: <20080714163107.GA936@sgi.com>
References: <20080709191439.GA7307@sgi.com> <20080711121736.18687570.akpm@linux-foundation.org> <20080714145255.GA23173@sgi.com> <20080714092451.2c81a472.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080714092451.2c81a472.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2008 at 09:24:51AM -0700, Andrew Morton wrote:
> On Mon, 14 Jul 2008 09:52:55 -0500 Jack Steiner <steiner@sgi.com> wrote:
> 
> > On Fri, Jul 11, 2008 at 12:17:36PM -0700, Andrew Morton wrote:
> > > On Wed, 9 Jul 2008 14:14:39 -0500 Jack Steiner <steiner@sgi.com> wrote:
> > > 
> > > > Open code the equivalent to follow_page(). This eliminates the
> > > > requirement for an EXPORT of follow_page().
> > > 
> > > I'd prefer to export follow_page() - copying-n-pasting just to avoid
> > > exporting the darn thing is silly.
> > 
> > If follow_page() can be EXPORTed, I think that may make the most sense for
> > now.
> 
> What was Christoph's reason for objecting to the export?

No clue. Just a NACK.

Christoph???

