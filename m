Return-Path: <linux-kernel-owner+w=401wt.eu-S1760929AbYFLNfL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760929AbYFLNfL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 09:35:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758399AbYFLNe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 09:34:59 -0400
Received: from www.tglx.de ([62.245.132.106]:39383 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758211AbYFLNe7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 09:34:59 -0400
Date: Thu, 12 Jun 2008 15:33:59 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel Walker <dwalker@mvista.com>
cc: linux-kernel@vger.kernel.org, Ulrich Drepper <drepper@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 5/5] futex: fix miss ordered wakeups
In-Reply-To: <1213277402.16459.25.camel@localhost.localdomain>
Message-ID: <alpine.LFD.1.10.0806121533270.3193@apollo.tec.linutronix.de>
References: <20080611204916.271608740@mvista.com>  <20080611204917.523866467@mvista.com>  <alpine.LFD.1.10.0806121022250.3193@apollo.tec.linutronix.de> <1213277402.16459.25.camel@localhost.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jun 2008, Daniel Walker wrote:
> On Thu, 2008-06-12 at 10:56 +0200, Thomas Gleixner wrote:
> > Please stop wasting everyone's time with that.
> 
> It achieves correct ordering of the futex waiters inside the kernel,
> that is in fact _something_ ..

Yeah, just something _useless_

Thanks,
	tglx
