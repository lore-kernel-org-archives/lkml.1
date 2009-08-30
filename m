Return-Path: <linux-kernel-owner+w=401wt.eu-S1753579AbZH3NTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579AbZH3NTo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 09:19:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753494AbZH3NTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 09:19:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48822 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753485AbZH3NTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 09:19:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mario <rety@poczta.onet.pl>
Subject: Re: Is acpi_ec_ecdt_probe() broken? (was: Re: ACPI locks hardware devices when it doesn't detect vista)
Date: Sun, 30 Aug 2009 15:20:40 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc8-rjw; KDE/4.3.0; x86_64; ; )
Cc: Maxim Levitsky <maximlevitsky@gmail.com>, Len Brown <lenb@kernel.org>,
       "linux-pm" <linux-pm@lists.linux-foundation.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>
References: <1250945310.14167.150.camel@maxim-laptop> <1251588634.15582.0.camel@maxim-laptop> <200908300859.29494.rety@poczta.onet.pl>
In-Reply-To: <200908300859.29494.rety@poczta.onet.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200908301520.40897.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 30 August 2009, Mario wrote:
> Maxim, 
> 
> I did the test regarding last coment from Alexey Starikovskiy on the bugzilla.
> 
> >What happens if acpi_ec_ecdt_probe() is not called at all? Do you have same
> >hang as with changed order?
> 
> That did it. System starts and MIR works ok without setpci solution.

Could you please put that information into the Bugzilla entry at
http://bugzilla.kernel.org/show_bug.cgi?id=14086 (you'll need to create a
Bugzilla account for yourself for this purpose, sorry for the inconvenience)?

The ACPI people generally use the Bugzilla rather than e-mail for tracking
bugs.

Best,
Rafael
