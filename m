Return-Path: <linux-kernel-owner+w=401wt.eu-S1752762AbYKXKzB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762AbYKXKzB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 05:55:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751918AbYKXKyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 05:54:53 -0500
Received: from gate.compton.nu ([217.169.19.106]:48829 "EHLO
	gosford.compton.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbYKXKyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 05:54:52 -0500
X-Greylist: delayed 4529 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Nov 2008 05:54:51 EST
Message-ID: <492A7632.4040106@compton.nu>
Date: Mon, 24 Nov 2008 09:38:58 +0000
From: Tom Hughes <tom@compton.nu>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Cristiano Prisciandaro <cristiano.p@solnet.ch>
CC: Dave Jones <davej@redhat.com>, cpufreq@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] cpufreq: eeepc 900 frequency scaling driver
References: <1227454026.7262.59.camel@localhost>
In-Reply-To: <1227454026.7262.59.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -2.6 (--)
X-Spam-Report: Spam detection software, running on the system "gosford.compton.nu", has
	identified this incoming email as possible spam.  The original message
	has been attached to this so you can view it (if it isn't spam) or label
	similar future email.  If you have any questions, see
	the administrator of that system for details.
	Content preview:  Cristiano Prisciandaro wrote: > From: Cristiano Prisciandaro
	<cristiano.p@solnet.ch> > > The bios of the eeepc 900 exposes an acpi method
	that allows clocking > the cpu to 630/900 MHz. This driver allows controlling
	the frequency > switch through the cpufreq subsystem. [...] 
	Content analysis details:   (-2.6 points, 5.0 required)
	pts rule name              description
	---- ---------------------- --------------------------------------------------
	-2.6 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cristiano Prisciandaro wrote:

> From: Cristiano Prisciandaro <cristiano.p@solnet.ch>
> 
> The bios of the eeepc 900 exposes an acpi method that allows clocking
> the cpu to 630/900 MHz. This driver allows controlling the frequency
> switch through the cpufreq subsystem.

I should perhaps add at this point that I have an alternative patch 
based on Cristiano's code, which adds this cpufreq driver to the 
existing eeepc-laptop module rather than creating a separate module for it.

Personally I'm quite happy with either solution so I'll leave it to you 
to decide what is the best way to go, but my patch is available if you 
want it.

Tom

-- 
Tom Hughes (tom@compton.nu)
http://www.compton.nu/
