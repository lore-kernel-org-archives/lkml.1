Return-Path: <linux-kernel-owner+w=401wt.eu-S1754130AbYKXQkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbYKXQkS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 11:40:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753920AbYKXQjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 11:39:54 -0500
Received: from gate.compton.nu ([217.169.19.106]:36844 "EHLO
	gosford.compton.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735AbYKXQjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 11:39:53 -0500
Message-ID: <492AD8C2.8020609@compton.nu>
Date: Mon, 24 Nov 2008 16:39:30 +0000
From: Tom Hughes <tom@compton.nu>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Thomas Renninger <trenn@suse.de>
CC: Cristiano Prisciandaro <cristiano.p@solnet.ch>,
       Dave Jones <davej@redhat.com>, cpufreq@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] cpufreq: eeepc 900 frequency scaling driver
References: <1227454026.7262.59.camel@localhost> <492A7632.4040106@compton.nu> <200811241613.25557.trenn@suse.de>
In-Reply-To: <200811241613.25557.trenn@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -2.6 (--)
X-Spam-Report: Spam detection software, running on the system "gosford.compton.nu", has
	identified this incoming email as possible spam.  The original message
	has been attached to this so you can view it (if it isn't spam) or label
	similar future email.  If you have any questions, see
	the administrator of that system for details.
	Content preview:  Thomas Renninger wrote: > Could you paste at least the whole
	ACPI device in which: > #define ASUS_CPUFV_READ_METHOD "CFVG" > #define ASUS_CPUFV_WRITE_METHOD
	"CFVS" > sit or better point to an acpidump/dsdt output. [...] 
	Content analysis details:   (-2.6 points, 5.0 required)
	pts rule name              description
	---- ---------------------- --------------------------------------------------
	-0.0 NO_RELAYS              Informational: message was not relayed via SMTP
	-2.6 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Renninger wrote:

> Could you paste at least the whole ACPI device in which:
> #define ASUS_CPUFV_READ_METHOD   "CFVG"
> #define ASUS_CPUFV_WRITE_METHOD  "CFVS"
> sit or better point to an acpidump/dsdt output.

There's a dump of DSDT on my Eee 900 at:

   http://www.compton.nu/eee900dsdt.dsl

Tom

-- 
Tom Hughes (tom@compton.nu)
http://www.compton.nu/
