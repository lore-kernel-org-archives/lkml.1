Return-Path: <linux-kernel-owner+w=401wt.eu-S939222AbXGSRU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939222AbXGSRU1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 13:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S940486AbXGSRTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 13:19:52 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:17118 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S940418AbXGSRTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 13:19:48 -0400
Subject: Re: [PATCH] [15/58] i386: Rewrite sched_clock
From: Daniel Walker <dwalker@mvista.com>
To: Andi Kleen <ak@suse.de>
Cc: patches@x86-64.org, linux-kernel@vger.kernel.org
In-Reply-To: <200707191913.27946.ak@suse.de>
References: <200707191154.642492000@suse.de>
	 <20070719095459.E60AD14E11@wotan.suse.de>
	 <1184863904.6458.17.camel@dhcp193.mvista.com>
	 <200707191913.27946.ak@suse.de>
Content-Type: text/plain
Date: Thu, 19 Jul 2007 10:15:38 -0700
Message-Id: <1184865339.6458.21.camel@dhcp193.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-19 at 19:13 +0200, Andi Kleen wrote:
> > What about using the cycles2ns() clocksource helpers, it would eliminate
> > the duplication of the shift/multiply math .
> 
> They are completely different from what clocksource provides.

How so?

Daniel

