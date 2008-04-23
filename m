Return-Path: <linux-kernel-owner+w=401wt.eu-S1751991AbYDWLOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991AbYDWLOZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 07:14:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751668AbYDWLOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 07:14:16 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:56753 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631AbYDWLOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 07:14:15 -0400
Date: Wed, 23 Apr 2008 05:13:58 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: Pull request for semaphore include changes
Message-ID: <20080423111358.GA11840@parisc-linux.org>
References: <20080419184029.GO20637@parisc-linux.org> <Pine.LNX.4.64.0804230917330.9710@anakin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804230917330.9710@anakin>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2008 at 09:18:13AM +0200, Geert Uytterhoeven wrote:
> drivers/input/serio/hp_sdc.c: In function 'hp_sdc_take':
> drivers/input/serio/hp_sdc.c:198: error: implicit declaration of function 'up'

Thanks, Geert.  It must've been pulled in implicitly before.  I'll take
care of this patch.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
