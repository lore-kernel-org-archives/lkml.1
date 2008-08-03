Return-Path: <linux-kernel-owner+w=401wt.eu-S1753861AbYHCByZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861AbYHCByZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 21:54:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751613AbYHCByP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 21:54:15 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:35258 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751180AbYHCByO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 21:54:14 -0400
Date: Sat, 2 Aug 2008 21:54:04 -0400
From: Theodore Tso <tytso@mit.edu>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       andi@firstfloor.org, Rik van Riel <riel@redhat.com>, mpm@selenic.com,
       Dave Chinner <david@fromorbit.com>
Subject: Re: [patch 14/19] Filesystem: Ext4 filesystem defrag
Message-ID: <20080803015404.GC11488@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Christoph Lameter <cl@linux-foundation.org>,
	Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
	Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
	andi@firstfloor.org, Rik van Riel <riel@redhat.com>,
	mpm@selenic.com, Dave Chinner <david@fromorbit.com>
References: <20080801182324.572058187@lameter.com> <20080801182347.191898393@lameter.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080801182347.191898393@lameter.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2008 at 07:21:15PM -0700, Christoph Lameter wrote:
> Support defragmentation for extX filesystem inodes

You forgot to change "extX" to "ext4".  :-)

> Reviewed-by: Rik van Riel <riel@redhat.com>
> Signed-off-by: Christoph Lameter <clameter@sgi.com>
> Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
Acked-by: "Theodore Ts'o" <tytso@mit.edu>

						- Ted
