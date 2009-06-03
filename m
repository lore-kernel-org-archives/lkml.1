Return-Path: <linux-kernel-owner+w=401wt.eu-S1753371AbZFCJ2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371AbZFCJ2R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 05:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752717AbZFCJ2B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 05:28:01 -0400
Received: from ryu.zarb.org ([212.85.158.22]:39982 "EHLO ryu.zarb.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752597AbZFCJ2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 05:28:00 -0400
Subject: Re: Stable regression 2.6.29.3 vs 2.6.29.2
From: Pascal Terjan <pterjan@mandriva.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       stable <stable@kernel.org>, linux-pci@vger.kernel.org
In-Reply-To: <4A25ADB6.2070503@kernel.org>
References: <1243625720.4426.0.camel@plop>  <4A203BFD.7040000@kernel.org>
	 <1243949325.19053.100.camel@plop>  <4A256050.2020305@kernel.org>
	 <1243969741.27062.11.camel@plop>  <4A258F1C.7030707@kernel.org>
	 <1243983068.1629.0.camel@plop>  <4A25ADB6.2070503@kernel.org>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Mandriva
Date: Wed, 03 Jun 2009 11:27:59 +0200
Message-Id: <1244021279.2481.32.camel@plop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1-1mdv2009.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 02 juin 2009 à 15:54 -0700, Yinghai Lu a écrit :
> Pascal Terjan wrote:
> > Le mardi 02 juin 2009 à 13:44 -0700, Yinghai Lu a écrit :
> >> Pascal Terjan wrote:
> >>> Le mardi 02 juin 2009 à 10:24 -0700, Yinghai Lu a écrit :
> >>> ACPI: Using IOAPIC for interrupt routing
> >>> PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 255
> >>> PCI: MCFG area at f0000000 reserved in ACPI motherboard resources
> >>> PCI: updated MCFG configuration 0: base f0000000 segment 0 buses 0 - 63
> >>> PCI: Using MMCONFIG for extended config space
> >> please check
> >>
> >> [PATCH] x86/pci: fix mmconfig detection with 32bit need 4g
> >>
> > 
> > I confirm that the machine boots fine with 2.6.29.4 + this patch
> 
> Thanks. Pascal
> 
> Can you try that on tip/master too?
> 

It had the bug and the patch fixes it there too

Thanks

