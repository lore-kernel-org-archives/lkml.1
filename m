Return-Path: <linux-kernel-owner+w=401wt.eu-S1755429AbXJBWig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429AbXJBWig (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 18:38:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753038AbXJBWi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 18:38:29 -0400
Received: from toq6.bellnexxia.net ([209.226.175.62]:51641 "EHLO
	toq6-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869AbXJBWi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 18:38:28 -0400
Subject: Re: yield API
From: Eric St-Laurent <ericstl34@sympatico.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Schwartz <davids@webmaster.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20071002064620.GA26638@elte.hu>
References: <20071001173159.GB2492@elte.hu>
	 <MDEHLPKNGKAHNMBLJOLKOEOBHCAC.davids@webmaster.com>
	 <20071002064620.GA26638@elte.hu>
Content-Type: text/plain
Date: Tue, 02 Oct 2007 17:57:51 -0400
Message-Id: <1191362271.29539.1.camel@perkele>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2007-10-02 at 08:46 +0200, Ingo Molnar wrote:

[...]

> APIs that are not in any real, meaningful use, despite a decade of 
> presence are not really interesting to me personally. (especially in 
> this case where we know exactly _why_ the API is used so rarely.) Sure 
> we'll continue to support it in the best possible way, with the usual 
> kernel maintainance policy: without hurting other, more commonly used 
> APIs. That was the principle we followed in previous schedulers too. And 
> if anyone has a patch to make sched_yield() better than it is today, i'm 
> of course interested in it.

Do you still have intentions to add a directed yield API?  I remember
seeing it in the earlier CFS patches.


- Eric


