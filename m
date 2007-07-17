Return-Path: <linux-kernel-owner+w=401wt.eu-S1761795AbXGQHje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761795AbXGQHje (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 03:39:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752134AbXGQHj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 03:39:26 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:10813 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131AbXGQHjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 03:39:25 -0400
From: Olaf Kirch <olaf.kirch@oracle.com>
Organization: Oracle
To: David Miller <davem@davemloft.net>
Subject: Re: [patch] revert: [NET]: Fix races in net_rx_action vs netpoll
Date: Tue, 17 Jul 2007 09:37:23 +0200
User-Agent: KMail/1.9.1
Cc: torvalds@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org
References: <20070716091236.GA10718@elte.hu> <alpine.LFD.0.999.0707161425361.20061@woody.linux-foundation.org> <20070716.150825.66176632.davem@davemloft.net>
In-Reply-To: <20070716.150825.66176632.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707170937.24430.olaf.kirch@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 July 2007 00:08, David Miller wrote:
> Sure, but I thought it would be nice to give Olaf a day or two to
> figure out what's going on rather than have the knee-jerk reaction to
> just revert.

Oh, reverting is fine with me. I'll just resubmit the patch.

Olaf
-- 
Olaf Kirch  |  --- o --- Nous sommes du soleil we love when we play
okir@lst.de |    / | \   sol.dhoop.naytheet.ah kin.ir.samse.qurax
