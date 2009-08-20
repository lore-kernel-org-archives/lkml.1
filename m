Return-Path: <linux-kernel-owner+w=401wt.eu-S1754027AbZHTMQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027AbZHTMQT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 08:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754216AbZHTMQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 08:16:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:59586 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754036AbZHTMQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 08:16:18 -0400
Subject: Re: [PATCH 0/6] Lazy workqueues
From: Peter Zijlstra <peterz@infradead.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, jeff@garzik.org, benh@kernel.crashing.org,
       htejun@gmail.com, bzolnier@gmail.com, alan@lxorguk.ukuu.org.uk,
       Junio C Hamano <junio@pobox.com>
In-Reply-To: <20090820120858.GJ12579@kernel.dk>
References: <1250763604-24355-1-git-send-email-jens.axboe@oracle.com>
	 <1250769861.8282.182.camel@twins>  <20090820120858.GJ12579@kernel.dk>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 20 Aug 2009 14:16:11 +0200
Message-Id: <1250770571.8282.186.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-20 at 14:08 +0200, Jens Axboe wrote:
> On Thu, Aug 20 2009, Peter Zijlstra wrote:
> > On Thu, 2009-08-20 at 12:19 +0200, Jens Axboe wrote:
> > > (sorry for the resend, but apparently the directory had some patches
> > >  in it already. plus, stupid git send-email doesn't default to
> > >  no chain replies, really annoying)
> > 
> > Newer versions should, I made a stink about this some time ago.
> 
> git version 1.6.4.173.g3f189
> 
> That's pretty new... But perhaps I should complain too, it's been
> annoying me forever.

http://marc.info/?l=git&m=123457137328461&w=2

Apparently it didn't happen, nor did I ever see a reply to that posting.

Junio, what happened here?
