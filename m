Return-Path: <linux-kernel-owner+w=401wt.eu-S1756111AbZAVMXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111AbZAVMXW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 07:23:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753027AbZAVMXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 07:23:12 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:59005 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752895AbZAVMXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 07:23:12 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jacek Luczak <difrost.kernel@gmail.com>
Subject: Re: [ACPI] GPE storm detected on FS Amilo Pro
Date: Thu, 22 Jan 2009 13:22:41 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc2-tst; KDE/4.1.3; x86_64; ; )
Cc: astarikovskiy@suse.de, len.brown@intel.com,
       LKML <linux-kernel@vger.kernel.org>
References: <4977352B.1040303@gmail.com> <200901211700.48357.rjw@sisk.pl> <497847D0.4050700@gmail.com>
In-Reply-To: <497847D0.4050700@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901221322.41970.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 January 2009, Jacek Luczak wrote:
> Hi Rafael,
> 
> > So everything appears to be OK except that your hardware has a problem,
> > which is correctly worked around and the message just tells you what happens.
> 
> Most probably yes, but I'm using that kernel really shortly so there might be
> some issues that I didn't noticed. This of course doesn't mean that here we have
>  bug, I was just bit confused with that message.
> 
> >> NOTE: In git kernel I've noticed that after boot and obtaining IP from DHCP I've
> >> got such message:
> >>
> >> Jan 21 14:44:32 difrost kernel: sky2 eth0: enabling interface
> >> Jan 21 14:44:33 difrost kernel: sky2 eth0: Link is up at 100 Mbps, full duplex,
> >> flow control rx
> >> Jan 21 14:45:36 difrost kernel: ACPI: EC: missing confirmations, switch off
> >> interrupt mode.
> >>
> >> This is not fully reproducible, didn't shown on [4].
> > 
> > This may be related to the issue behind the GPM storm message.
> 
> Is it sth serious? I'm really lost here.

No, I don't think it's serious.  As long as everything works, there's not need
to worry. :-)

Thanks,
Rafael
