Return-Path: <linux-kernel-owner+w=401wt.eu-S1754971AbYJPPfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971AbYJPPfZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 11:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751544AbYJPPfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 11:35:15 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:46601 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751507AbYJPPfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 11:35:14 -0400
Date: Thu, 16 Oct 2008 11:35:12 -0400
From: Theodore Tso <tytso@mit.edu>
To: linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel version numbering scheme change
Message-ID: <20081016153512.GE12962@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	linux-kernel@vger.kernel.org
References: <20081016002509.GA25868@kroah.com> <20081016142619.GA3756@tatooine.rebelbase.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081016142619.GA3756@tatooine.rebelbase.local>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2008 at 04:26:19PM +0200, markus reichelt wrote:
> Why not just keep it? It has worked so far, and from a strictly
> end-user point of view I cannot see any advantages at all with a new
> scheme. The ideas mentioned so far don't cut it either.

I'd cast a vote for keeping it as well.  "2.6" is actually a great
marker so that people know that it's highly likely the version number
is for the Linux kernel.  Contrast "I'm running 2.6.27" versus "I'm
running 27" (huh, what does that mean?) or "I'm running the 27 kernel"
or "I'm running Linux kernel version 27" or worse yet "I'm running
2008-03".  Something like "2.6.27" is just easier to say, and less
prone to misunderstanding/confusion.

Let's just leave things the way they are.

					- Ted
