Return-Path: <linux-kernel-owner+w=401wt.eu-S1767167AbXCILVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767167AbXCILVl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 06:21:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767174AbXCILVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 06:21:41 -0500
Received: from thunk.org ([69.25.196.29]:58115 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767167AbXCILVj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 06:21:39 -0500
Date: Fri, 9 Mar 2007 06:27:23 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Use more gcc extensions in the Linux headers
Message-ID: <20070309112722.GA19070@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Rusty Russell <rusty@rustcorp.com.au>,
	lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>
References: <1173419792.32234.131.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173419792.32234.131.camel@localhost.localdomain>
User-Agent: Mutt/1.5.9i
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2007 at 04:56:32PM +1100, Rusty Russell wrote:
> __builtin_types_compatible_p() has been around since gcc 2.95, and we
> don't use it anywhere.  This patch quietly fixes that.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Is your clock set correctly?  Looks like this mail was sent 23 days
early.  :-)

						- Ted

