Return-Path: <linux-kernel-owner+w=401wt.eu-S1757070AbYLCXry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757070AbYLCXry (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 18:47:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755231AbYLCXrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 18:47:32 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39179 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755048AbYLCXrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 18:47:31 -0500
Date: Wed, 3 Dec 2008 15:46:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: rusty@rustcorp.com.au, rmk+lkml@arm.linux.org.uk,
       linux-kernel@vger.kernel.org, sfr@canb.auug.org.au
Subject: Re: Yet more ARM breakage in linux-next
Message-Id: <20081203154629.bba4e5e4.akpm@linux-foundation.org>
In-Reply-To: <49371848.2080804@oracle.com>
References: <20081203192905.GA12502@flint.arm.linux.org.uk>
	<20081203124109.79f8f15b.akpm@linux-foundation.org>
	<200812040952.44957.rusty@rustcorp.com.au>
	<49371848.2080804@oracle.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Dec 2008 15:37:44 -0800
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> > (Yes, classic useless kerneldoc documentation doesn't actually *say* 
> > this clearly).
>  
> oh fud.  That's not a fault of kernel-doc, just of whoever wrote it.
> It's only as good as someone makes it.

For some reason, the act of typing in some kerneldoc makes people's
brains turn off.  Perhaps it's because "oh, I am supposed to type some
documentation here" instead of "gee, I think this code is unclear,
let's clarify that".

