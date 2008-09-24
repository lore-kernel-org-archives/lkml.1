Return-Path: <linux-kernel-owner+w=401wt.eu-S1754078AbYIXVO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078AbYIXVO7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 17:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752933AbYIXVOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 17:14:49 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38667 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751616AbYIXVOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 17:14:48 -0400
Date: Wed, 24 Sep 2008 22:14:25 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Jesse Brandeburg <jesse.brandeburg@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, arjan@linux.intel.com,
       reiserfs-devel@vger.kernel.org, peterz@infradead.org
Subject: Re: [LOCKDEP linux-2.6.27-rc7] reiserfs circular locking
Message-ID: <20080924221425.3b4939ba@lxorguk.ukuu.org.uk>
In-Reply-To: <48DA8D27.5080908@suse.com>
References: <4807377b0809241139x18ea8ce4x7dbc66ba680be3e7@mail.gmail.com>
	<48DA8D27.5080908@suse.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I have a reiserfs patch set that should address this. I haven't
> submitted it recently because I'm chasing down a reiserfs bug report
> that may or may not be related to the patch set.
> 
> You can grab the patch set out of an opensuse kernel src rpm.

Jeff: See also bugzilla.kernel.org #9136 which seems to match

BTW - does anyone have a view where the existing reiserfs bugs should be
assigned as they are currently assigned to namesys...

Alan

