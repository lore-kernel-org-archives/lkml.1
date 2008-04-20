Return-Path: <linux-kernel-owner+w=401wt.eu-S1756931AbYDTWtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931AbYDTWtq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 18:49:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753216AbYDTWtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 18:49:39 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:36810 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752895AbYDTWti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 18:49:38 -0400
Message-ID: <480BC87C.9060305@garzik.org>
Date: Sun, 20 Apr 2008 18:49:32 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Russell King <rmk+lkml@arm.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
CC: linux-arm-kernel@lists.arm.linux.org.uk, kernel@wantstofly.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/15] ARM minor irq handler cleanups
References: <d7afbccda111e535bb14ad8082b208c7a2cd9833.1208559659.git.jgarzik@redhat.com> <20080418164411.b1e1628d.akpm@linux-foundation.org> <48093AF3.2080807@garzik.org> <20080418181741.d6f365c5.akpm@linux-foundation.org> <480BC0FC.8020908@garzik.org> <20080420224008.GB8733@flint.arm.linux.org.uk>
In-Reply-To: <20080420224008.GB8733@flint.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King wrote:
> On Sun, Apr 20, 2008 at 06:17:32PM -0400, Jeff Garzik wrote:
>> Andrew Morton wrote:
>>> If we had a migration plan (ie: request_irq_new(), above) then this of
>>> course wouldn't be a problem.
>> A fair comment...
> 
> Then we'll be stuck with request_irq_new() for the next 10 years or so.

(un-hijacking topic <grin>)

Another fair comment.  I am secretly hoping for the ease of a flag day 
(a la pt_regs) rather than a decade-long transition, but I readily to 
confess to dodging the entire issue by doing all these cleanups first :)

	Jeff




