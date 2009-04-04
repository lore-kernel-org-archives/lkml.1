Return-Path: <linux-kernel-owner+w=401wt.eu-S1754889AbZDDUzN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889AbZDDUzN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 16:55:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753585AbZDDUy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 16:54:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:59336 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622AbZDDUy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 16:54:56 -0400
Date: Sat, 4 Apr 2009 13:56:20 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
       Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Re: [GIT PULL] Ext3 latency fixes
Message-ID: <20090404135620.79d8cb3e@infradead.org>
In-Reply-To: <20090404173412.GF5178@kernel.dk>
References: <1238742067-30814-1-git-send-email-tytso@mit.edu>
	<alpine.LFD.2.00.0904031110420.19690@localhost.localdomain>
	<alpine.LFD.2.00.0904031150190.4015@localhost.localdomain>
	<alpine.LFD.2.00.0904031329410.7007@localhost.localdomain>
	<20090404135719.GA9812@mit.edu>
	<20090404151649.GE5178@kernel.dk>
	<alpine.LFD.2.00.0904040854470.3915@localhost.localdomain>
	<20090404173412.GF5178@kernel.dk>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 4 Apr 2009 19:34:12 +0200
Jens Axboe <jens.axboe@oracle.com> wrote:

> > Latency is more important than throughput. It's that simple.
> 
> It's really not that simple, otherwise the schedulers would be much
> simpler. It's pretty easy to get good latency if you disregard any
> throughput concerns, 

I'd be very interested in a scheduler like that.....
How much work would it be to make it ?

(if nothing else it would be a good number to have "should be within
50% of the perfect one for the tradeoff")


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
