Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522Ab0BARx3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 12:53:29 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:39069 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613Ab0BARx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 12:53:27 -0500
Date: Mon, 1 Feb 2010 11:52:36 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Andi Kleen <andi@firstfloor.org>
cc: Dave Chinner <david@fromorbit.com>, Rik van Riel <riel@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
       Miklos Szeredi <miklos@szeredi.hu>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickins <hugh@veritas.com>,
       linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk
Subject: Re: Slab Fragmentation Reduction V15
In-Reply-To: <20100130104812.GE29555@one.firstfloor.org>
Message-ID: <alpine.DEB.2.00.1002011152130.30861@router.home>
References: <20100129204931.789743493@quilx.com> <20100130104812.GE29555@one.firstfloor.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Jan 2010, Andi Kleen wrote:

> I guess the problem could be simplified by ignoring dentries in "unusual"
> states?

Sure.

