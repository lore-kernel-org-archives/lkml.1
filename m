Return-Path: <linux-kernel-owner+w=401wt.eu-S1752770AbZH2WhP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770AbZH2WhP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 18:37:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752753AbZH2WhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 18:37:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47526 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752750AbZH2WhO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 18:37:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mario <rety@poczta.onet.pl>
Subject: Re: Is acpi_ec_ecdt_probe() broken? (was: Re: ACPI locks hardware devices when it doesn't detect vista)
Date: Sun, 30 Aug 2009 00:37:45 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc8-rjw; KDE/4.3.0; x86_64; ; )
Cc: Maxim Levitsky <maximlevitsky@gmail.com>, Len Brown <lenb@kernel.org>,
       "linux-pm" <linux-pm@lists.linux-foundation.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>
References: <1250945310.14167.150.camel@maxim-laptop> <1251575484.10321.11.camel@maxim-laptop> <200908292305.55050.rety@poczta.onet.pl>
In-Reply-To: <200908292305.55050.rety@poczta.onet.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <200908300037.45412.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 29 August 2009, Mario wrote:
> Exact model is Compal JFL92.
> I've attached a dmidecode output.

OK

Maxim, Mario, can you create a bug entry in the kernel Bugzilla for this
issue and put my address into the CC list in there?

Best,
Rafael
