Return-Path: <linux-kernel-owner+w=401wt.eu-S1752105AbYAPIxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105AbYAPIxA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 03:53:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751301AbYAPIwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 03:52:51 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47075 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbYAPIwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 03:52:50 -0500
Date: Wed, 16 Jan 2008 08:51:56 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>, ananth@in.ibm.com,
       dhowells@redhat.com, jdike@addtoit.com, sam@ravnborg.org,
       Adrian Bunk <adrian.bunk@movial.fi>,
       Randy Dunlap <randy.dunlap@oracle.com>, phil.el@wanadoo.fr,
       oprofile-list@lists.sourceforge.net
Subject: Re: [PATCH for -mm] Fix ARM to play nicely with generic Instrumentation menu
Message-ID: <20080116085155.GA11617@flint.arm.linux.org.uk>
References: <20080116025341.GA31346@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080116025341.GA31346@Krystal>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2008 at 09:53:41PM -0500, Mathieu Desnoyers wrote:
> This patch cleans up the fix from Linus so it does not conflict with the
> following patches in -mm.

What following patches?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
