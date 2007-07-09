Return-Path: <linux-kernel-owner+w=401wt.eu-S1756205AbXGILdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205AbXGILdi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 07:33:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751757AbXGILdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 07:33:31 -0400
Received: from no-way.org ([212.55.212.131]:41982 "EHLO no-way.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835AbXGILda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 07:33:30 -0400
X-Greylist: delayed 1704 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Jul 2007 07:33:30 EDT
Date: Mon, 9 Jul 2007 12:45:25 +0200
From: Flavio Curti <fcu@no-way.org>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Flavio Curti <lists.fcu@no-way.org>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: panics with 16port Promise Supertrack EX Controller
Message-ID: <20070709104525.GE16285@no-way.org>
References: <20070708225246.GD16285@no-way.org> <6bffcb0e0707081620pf4afd46re9e74e18518b352a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6bffcb0e0707081620pf4afd46re9e74e18518b352a@mail.gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2007 at 01:20:51AM +0200, Michal Piotrowski wrote:
> On 09/07/07, Flavio Curti <lists.fcu@no-way.org> wrote:
> Jul  8 00:19:13 dorade.cyberlink.ch EFLAGS: 00210046   
> (2.6.22-rc7-dorade #1)
> Is this a regression?

I also tried 2.6.21.5, which showed the same problem. So I doubt it's a
2.6.22rc7 problem.

I'll try a different scheduler as suggested.

Kind regards

Flavio Curti

--
http://no-way.org/~fcu/
