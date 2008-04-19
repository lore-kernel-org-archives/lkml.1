Return-Path: <linux-kernel-owner+w=401wt.eu-S1759985AbYDSCsP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759985AbYDSCsP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 22:48:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751368AbYDSCsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 22:48:04 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:44913 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174AbYDSCsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 22:48:03 -0400
Message-ID: <48095E1D.1050700@keyaccess.nl>
Date: Sat, 19 Apr 2008 04:51:09 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] ftrace: simplify hex print
References: <alpine.LFD.1.10.0804181430310.3261@apollo.tec.linutronix.de> <20080418123502.GB17013@elte.hu>
In-Reply-To: <20080418123502.GB17013@elte.hu>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18-04-08 14:35, Ingo Molnar wrote:

> * Thomas Gleixner <tglx@linutronix.de> wrote:
> 
>> simplify hex to ascii conversion with a lookup table.
> 
> thanks Thomas, applied.

There is a hex_asc() in kernel.h

Rene.

