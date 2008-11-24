Return-Path: <linux-kernel-owner+w=401wt.eu-S1754117AbYKXRIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117AbYKXRIS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 12:08:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753223AbYKXRID
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 12:08:03 -0500
Received: from gate.compton.nu ([217.169.19.106]:44603 "EHLO
	gosford.compton.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935AbYKXRIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 12:08:01 -0500
Message-ID: <492ADF5E.2050709@compton.nu>
Date: Mon, 24 Nov 2008 17:07:42 +0000
From: Tom Hughes <tom@compton.nu>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Corentin Chary <corentin.chary@gmail.com>
CC: Thomas Renninger <trenn@suse.de>, acpi4asus-user@lists.sourceforge.net,
       Dave Jones <davej@redhat.com>,
       Cristiano Prisciandaro <cristiano.p@solnet.ch>,
       linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Subject: Re: [Acpi4asus-user] [PATCH 1/1] cpufreq: eeepc 900 frequency scaling
 driver
References: <1227454026.7262.59.camel@localhost> <492A7632.4040106@compton.nu>	 <200811241613.25557.trenn@suse.de> <200811241736.53067.trenn@suse.de>	 <71cd59b00811240841j69451aafje5cbb5204dbff2e5@mail.gmail.com>	 <492ADACC.6030807@compton.nu> <71cd59b00811240858p3b830c73qc2742023d2977054@mail.gmail.com>
In-Reply-To: <71cd59b00811240858p3b830c73qc2742023d2977054@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -2.6 (--)
X-Spam-Report: Spam detection software, running on the system "gosford.compton.nu", has
	identified this incoming email as possible spam.  The original message
	has been attached to this so you can view it (if it isn't spam) or label
	similar future email.  If you have any questions, see
	the administrator of that system for details.
	Content preview:  Corentin Chary wrote: > Just modprobe p4-clockmod > - use
	cpufreq to go to the lower frequency > - run something cpu intensive > - go
	to the higher frequency (900mghz) > - you'll see the difference > > at least,
	it works with my eeepc 700, maybe 900 is different for that, > but it seems
	unlikely to me. [...] 
	Content analysis details:   (-2.6 points, 5.0 required)
	pts rule name              description
	---- ---------------------- --------------------------------------------------
	-0.0 NO_RELAYS              Informational: message was not relayed via SMTP
	-2.6 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corentin Chary wrote:

> Just modprobe p4-clockmod
> - use cpufreq to go to the lower frequency
> - run something cpu intensive
> - go to the higher frequency (900mghz)
> - you'll see the difference
> 
> at least, it works with my eeepc 700, maybe 900 is different for that,
> but it seems unlikely to me.

Have a look at http://www.codemonkey.org.uk/projects/eeepc/ for an 
explanation of what p4-clockmod does and why it isn't really changing 
the speed of the processor (but does cause you to get less work done).

tom

-- 
Tom Hughes (tom@compton.nu)
http://www.compton.nu/
