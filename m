Return-Path: <linux-kernel-owner+w=401wt.eu-S933065AbYBHSji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933065AbYBHSji (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 13:39:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758534AbYBHSja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 13:39:30 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52802 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758559AbYBHSj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 13:39:29 -0500
Date: Fri, 8 Feb 2008 12:39:25 -0600
From: Paul Jackson <pj@sgi.com>
To: Olof Johansson <olof@lixom.net>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, paulus@samba.org,
       tglx@linutronix.de, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [PATCH] Fix compilation of powerpc asm-offsets.c with old gcc
Message-Id: <20080208123925.4c234aa8.pj@sgi.com>
In-Reply-To: <20080208182343.GB10295@lixom.net>
References: <18347.34100.60973.215093@cargo.ozlabs.ibm.com>
	<alpine.LFD.1.00.0802071449240.2896@woody.linux-foundation.org>
	<20080208120623.3ad74e3a.pj@sgi.com>
	<20080208182154.GA10295@lixom.net>
	<20080208182343.GB10295@lixom.net>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, Olof and Harvey.

  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=

Just what I was looking for.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
