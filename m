Return-Path: <linux-kernel-owner+w=401wt.eu-S1756919AbXIQTN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919AbXIQTN7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 15:13:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753592AbXIQTNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 15:13:50 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:49217 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754913AbXIQTNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 15:13:49 -0400
Date: Mon, 17 Sep 2007 12:13:47 -0700
From: Paul Jackson <pj@sgi.com>
To: "Paul Menage" <menage@google.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: task containersv11 kernel BUG at include/linux/dcache.h:323
Message-Id: <20070917121347.345b7d05.pj@sgi.com>
In-Reply-To: <6599ad830709171126l7f178404tbb37e916767a3956@mail.gmail.com>
References: <20070916045438.9585.46625.sendpatchset@jackhammer.engr.sgi.com>
	<6599ad830709171126l7f178404tbb37e916767a3956@mail.gmail.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul M wrote:
> This is already fixed in -mm

I'm missing a clue ... the latest *-mm below

  ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/

I see is:

  2.6.23-rc4/2.6.23-rc4-mm1/

dated two weeks ago, without this fix.

I also don't see any mention of this fix in any recent
lkml or linux-mm mailing list messages.

What am I missing?  Where is this patch?

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
