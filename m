Return-Path: <linux-kernel-owner+w=401wt.eu-S1755092AbZFHMBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092AbZFHMBf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 08:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754834AbZFHMB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 08:01:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:65333 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754748AbZFHMB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 08:01:27 -0400
Date: Mon, 8 Jun 2009 08:01:27 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Huang Ying <ying.huang@intel.com>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@linux.intel.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v5] x86: MCE: Re-implement MCE log ring buffer as per-CPU
 ring buffer
In-Reply-To: <1244449602.8361.587.camel@yhuang-dev.sh.intel.com>
Message-ID: <alpine.DEB.2.00.0906080800020.9522@gandalf.stny.rr.com>
References: <1244445115.8361.576.camel@yhuang-dev.sh.intel.com>  <20090608072030.GA6732@elte.hu>  <1244446222.8361.584.camel@yhuang-dev.sh.intel.com>  <20090608073845.GA32745@elte.hu> <1244449602.8361.587.camel@yhuang-dev.sh.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 8 Jun 2009, Huang Ying wrote:
> 
> Steve have said he has a NMI-safe solution, but it is under patent
> application. It seems that patent application will take very long time,
> so we decide to enhance mce log buffer instead of waiting.

Note, the application was finished last week. The wait now is for me to 
port the code back to the latest kernel (things has changed since then). 
I've just been too busy trying to get other things working. I'll get the 
code out this week.

-- Steve

