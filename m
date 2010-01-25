Return-Path: <linux-kernel-owner+w=401wt.eu-S1753726Ab0AYWib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726Ab0AYWib (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 17:38:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751368Ab0AYWia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 17:38:30 -0500
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:51269 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932131Ab0AYWia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 17:38:30 -0500
Date: Mon, 25 Jan 2010 22:38:16 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Ian Campbell <ijc@hellion.org.uk>, Valdis.Kletnieks@vt.edu,
       linux-kernel@vger.kernel.org
Subject: Re: High pitch noise when ACPI processor module is loaded.
Message-ID: <20100125223816.GA16685@sucs.org>
References: <alpine.DEB.2.00.1001231046080.1064@p34.internal.lan> <9883.1264397678@localhost> <alpine.DEB.2.00.1001250424540.4502@p34.internal.lan> <1264414241.16526.84480.camel@zakaz.uk.xensource.com> <alpine.DEB.2.00.1001251543450.4578@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1001251543450.4578@p34.internal.lan>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 25, 2010 at 03:46:06PM -0500, Justin Piszcz wrote:
>
> It would be nice if it were possible to find out what is causing it exactly
> in the acpi cpufreq module, as this problem does not occur in Windows 7 and
> I can achieve 3.6GHz in Windows 7 w/out any high pitch noise.

That may well be related to the interrupt frequency the kernel is
running with. I remember reading that a lower HZ were less likely to
cause chip whine on some machines...

http://www.thinkwiki.org/wiki/Problem_with_high_pitch_noises#Change_the_timer_interrupt_frequency

-- 
Sitsofe | http://sucs.org/~sits/
