Return-Path: <linux-kernel-owner+w=401wt.eu-S1763644AbXFKAJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763644AbXFKAJU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 20:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760540AbXFKAJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 20:09:12 -0400
Received: from ozlabs.org ([203.10.76.45]:37009 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315AbXFKAJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 20:09:11 -0400
Subject: Re: [PATCH RFC] struct list_node
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.0.98.0706101317090.14121@woody.linux-foundation.org>
References: <1181452290.16428.7.camel@localhost.localdomain>
	 <alpine.LFD.0.98.0706101013420.20321@woody.linux-foundation.org>
	 <alpine.LFD.0.98.0706101317090.14121@woody.linux-foundation.org>
Content-Type: text/plain
Date: Mon, 11 Jun 2007 10:08:59 +1000
Message-Id: <1181520539.16428.77.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-06-10 at 13:19 -0700, Linus Torvalds wrote:
> And if you want a head, you really do want to use "hlist", since the head 
> is smaller than a list entry (a single pointer rather than two).

No, now you're entirely missing the point.

The normal Linux lists are beautiful, and should be used!  I share your
enthusiasm for them.

They could just use a little more type safety for the common case.  That
is all.

Hope that clarifies,
Rusty.

