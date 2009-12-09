Return-Path: <linux-kernel-owner+w=401wt.eu-S1753499AbZLIFb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499AbZLIFb7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 00:31:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752843AbZLIFby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 00:31:54 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:36054 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807AbZLIFby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 00:31:54 -0500
X-Authority-Analysis: v=1.0 c=1 a=eMe6h4DZu64A:10 a=7U3hwN5JcxgA:10 a=AZr8GnUNh-JViSuHNqsA:9 a=rJpVuga4aBbMdVxFdZ1uQCj1stEA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: CONFIG_FTRACE_STARTUP_TEST in 2.6.32
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Jon Masters <jonathan@jonmasters.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1260335831.3027.400.camel@tonnant>
References: <1260335831.3027.400.camel@tonnant>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 09 Dec 2009 00:31:59 -0500
Message-ID: <1260336719.2146.61.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-09 at 00:17 -0500, Jon Masters wrote:
> Steven,
> 
> FYI I built a Linus tree yesterday with CONFIG_FTRACE_STARTUP_TEST
> enabled (as well as *all* other debug options, per usual setup) on a KVM
> instance running F12 userspace with otherwise "make localmodconfig".
> 
> The kernel stalls at the ftrace tester and I eventually rebooted it. I
> didn't have any time to poke further, but I can do so if you don't
> already know about this problem.

Nope, I don't know of this. Although someone did tell me that they had a
bug with KVM and tracing. I got side tracked from debugging that. (still
kind of low priority).

But where exactly did it get stuck?

-- Steve


