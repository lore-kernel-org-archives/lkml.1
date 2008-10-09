Return-Path: <linux-kernel-owner+w=401wt.eu-S1757635AbYJIVwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757635AbYJIVwe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 17:52:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757382AbYJIVv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 17:51:57 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57016 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755856AbYJIVv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 17:51:56 -0400
Date: Thu, 9 Oct 2008 22:51:43 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Davi Leal <davi@leals.com>
Cc: linux-kernel@vger.kernel.org, gnuherds-app-dev@nongnu.org
Subject: Re: free tg3 ethernet driver
Message-ID: <20081009225143.7999311d@lxorguk.ukuu.org.uk>
In-Reply-To: <200810092236.58534.davi@leals.com>
References: <200810082353.31033.davi@leals.com>
	<20081008230827.6e1423fe@lxorguk.ukuu.org.uk>
	<200810092236.58534.davi@leals.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Oct 2008 22:36:57 +0200
Davi Leal <davi@leals.com> wrote:

> Alan Cox wrote:
> > Well if you want to write new firmware for the device you'll need to
> > reverse engineer the chip internals or convince Broadcom to document them
> > for you. I suspect you'll have to get to the point of xraying the
> > component slice by slice and need a multi-million dollar budget.
> 
> People position seem to be continue to pledge to pay $151 to the developer(s) 
> (even if it's Broadcom in case they apply to the pledge system) who provide a 
> free driver for tg3 devices.

Well thats good, another 1.999849 million dollars and you might get
started.

With the best will in the world if you go and pay Broadcom zillions to
open source the firmware the only incentive you create is for them to
keep future firmware proprietary to sell to you next time around.

If on the other hand you buy non Broadcom equipment if you feel this
way about the firmware then you create a far better economic incentive,
and at $10 a NIC its not really hard to do that.

Alan
