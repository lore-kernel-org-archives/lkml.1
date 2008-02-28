Return-Path: <linux-kernel-owner+w=401wt.eu-S1755585AbYB1KUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585AbYB1KUl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 05:20:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758780AbYB1KU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 05:20:28 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:58850 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758740AbYB1KU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 05:20:27 -0500
Subject: Re: [RFC/PATCH 1/4] sched: remove isolcpus
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Max Krasnyanskiy <maxk@qualcomm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Oleg Nesterov <oleg@tv-sign.ru>, Steven Rostedt <rostedt@goodmis.org>,
       Paul Jackson <pj@sgi.com>, linux-kernel@vger.kernel.org
In-Reply-To: <47C5F8E0.3060708@qualcomm.com>
References: <20080227222103.673194000@chello.nl>
	 <20080227222542.056473000@chello.nl>  <47C5F8E0.3060708@qualcomm.com>
Content-Type: text/plain
Date: Thu, 28 Feb 2008 11:19:45 +0100
Message-Id: <1204193985.6243.27.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-02-27 at 15:57 -0800, Max Krasnyanskiy wrote:
> Peter Zijlstra wrote:
> 
> > cpu isolation doesn't offer anything over cpusets, hence remove it.
> 
> Works for me. That's what I suggested in my reply to your comments.
> Here is the quote from the previous thread:

Dude, I've been pushing a cpuset interface from the get go.

