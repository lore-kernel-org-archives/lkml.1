Return-Path: <linux-kernel-owner+w=401wt.eu-S1756036AbYAQQU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036AbYAQQU3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 11:20:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752668AbYAQQUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 11:20:20 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:49780 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590AbYAQQUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 11:20:19 -0500
Subject: Re: 2.6.24-rc8-rt1
From: Daniel Walker <dwalker@mvista.com>
To: Wolfgang Grandegger <wg@grandegger.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <478F2A46.5070506@grandegger.com>
References: <1200544050.318.18.camel@localhost.localdomain>
	 <478F2A46.5070506@grandegger.com>
Content-Type: text/plain
Date: Thu, 17 Jan 2008 08:17:12 -0800
Message-Id: <1200586632.18731.141.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-01-17 at 11:13 +0100, Wolfgang Grandegger wrote:
> Steven Rostedt wrote:
> > We are pleased to announce the 2.6.24-rc8-rt1 tree, which can be
> > downloaded from the location:
> > 
> >   http://rt.et.redhat.com/download/
> 
> It builds and runs fine on my Icecube-MPC5200 board, now also with the
> latency tracer enabled. That's great. Still, "cyclictest -n -p80 -i1000"
> reports latencies up to 400 us and therefore I tried to trigger and save
> a high latency trace using:

Do you happen to have a boot log (dmesg) for this system?

Daniel

