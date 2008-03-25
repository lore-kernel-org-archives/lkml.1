Return-Path: <linux-kernel-owner+w=401wt.eu-S1758521AbYCYQLa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758521AbYCYQLa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 12:11:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756203AbYCYQLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 12:11:21 -0400
Received: from one.firstfloor.org ([213.235.205.2]:32821 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756112AbYCYQLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 12:11:21 -0400
Date: Tue, 25 Mar 2008 17:14:30 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>, andreas.herrmann3@amd.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] CPA: Add statistics about state of direct mapping v3
Message-ID: <20080325161430.GR2170@one.firstfloor.org>
References: <20080312353.598285931@firstfloor.org> <20080312025333.BAF5F1B41D1@basil.firstfloor.org> <alpine.LFD.1.00.0803211822220.3781@apollo.tec.linutronix.de> <20080321175538.GI2346@one.firstfloor.org> <20080322095041.GA20734@basil.nowhere.org> <alpine.LFD.1.00.0803251631050.3781@apollo.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0803251631050.3781@apollo.tec.linutronix.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2008 at 04:40:43PM +0100, Thomas Gleixner wrote:
> On Sat, 22 Mar 2008, Andi Kleen wrote:
> 
> > [I didn't switch to debugfs because I strongly disagreed with that
> > suggestion. But all the other points you made are addressed.]
> 
> Halfways :)

Ok.

> > +	update_page_count(PG_LEVEL_1G, pages);
> > +
> 
>   update via function call with pages = 0 ?

Didn't get that one. Can you clarify?

-Andi
