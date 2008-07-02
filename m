Return-Path: <linux-kernel-owner+w=401wt.eu-S1753638AbYGBIJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638AbYGBIJS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 04:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752181AbYGBIJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 04:09:04 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:53219 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbYGBIJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 04:09:02 -0400
X-Auth-Info: L71IE/4636TF4xgo/ZMr0huKfaeEPRUr3EKgPeAP/8o=
X-Auth-Info: L71IE/4636TF4xgo/ZMr0huKfaeEPRUr3EKgPeAP/8o=
X-Auth-Info: 2CPQu/1jn8NolWVGvWHWmyCuTyou1dw1Jrb9Csiwsk4=
X-Auth-Info: 2CPQu/1jn8NolWVGvWHWmyCuTyou1dw1Jrb9Csiwsk4=
X-Auth-Info: 2CPQu/1jn8NolWVGvWHWmyCuTyou1dw1Jrb9Csiwsk4=
X-Auth-Info: 2CPQu/1jn8NolWVGvWHWmyCuTyou1dw1Jrb9Csiwsk4=
X-Auth-Info: 2CPQu/1jn8NolWVGvWHWmyCuTyou1dw1Jrb9Csiwsk4=
Message-ID: <486B37BF.6030107@grandegger.com>
Date: Wed, 02 Jul 2008 10:09:35 +0200
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Luotao Fu <l.fu@pengutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.24-rc8-rt1: Strange latencies on mpc5200 powerpc - RCU issue?
References: <47976D06.1010900@grandegger.com> <479DF0A1.3000906@pengutronix.de> <479DF711.5090406@grandegger.com> <479F186A.4020004@pengutronix.de> <479F2C3C.1020203@grandegger.com> <20080130010716.GB16069@linux.vnet.ibm.com> <47A032E9.4080105@grandegger.com> <20080130102255.GA24890@linux.vnet.ibm.com> <47A0552D.20605@grandegger.com> <20080130105715.GE24890@linux.vnet.ibm.com> <20080130111559.GC20089@pengutronix.de> <486A3EBB.6030905@grandegger.com> <Pine.LNX.4.58.0807011036510.26650@gandalf.stny.rr.com>
In-Reply-To: <Pine.LNX.4.58.0807011036510.26650@gandalf.stny.rr.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Tue, 1 Jul 2008, Wolfgang Grandegger wrote:
>> I continue this thread because it's still not understood why enabling
>> CONFIG_RCU_TRACE is necessary to get reasonable latencies on the
>> MPC5200. It might also explain, why I get much worse latencies with
>> 2.6.25.8-rt7.
> 
> Have you tried turning on ftrace?

Hm, is it available for PowerPC? I have not found yet how to enable it.

Wolfgang.
