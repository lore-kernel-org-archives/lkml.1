Return-Path: <linux-kernel-owner+w=401wt.eu-S1753527AbYLBUig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527AbYLBUig (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 15:38:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750982AbYLBUi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 15:38:28 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52124 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbYLBUi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 15:38:28 -0500
Date: Tue, 2 Dec 2008 15:36:24 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org
Subject: Re: [ltt-dev] [PATCH] add tracepoints to track change in napi
	states on network receive
Message-ID: <20081202203624.GB30042@hmsreliant.think-freely.org>
References: <20081202195129.GA30042@hmsreliant.think-freely.org> <20081202200150.GA27282@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081202200150.GA27282@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2008 at 03:01:50PM -0500, Mathieu Desnoyers wrote:
> * Neil Horman (nhorman@tuxdriver.com) wrote:
> > Hey there-
> > 	I thought it would be handy to track the napi receive state of different
> > network devices using ltt.  This patch adds trace points to indicate when a napi
> > instance has been scheduled, when its serviced and when it completes.
> > 
> 
> Sounds great, see comments below,
> 
That all looks good.  I'll revise and repost in the morning.

Thanks & Regards
Neil



-- 
/****************************************************
 * Neil Horman <nhorman@tuxdriver.com>
 * Software Engineer, Red Hat
 ****************************************************/
