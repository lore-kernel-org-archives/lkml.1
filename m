Return-Path: <linux-kernel-owner+w=401wt.eu-S1753736AbYHLTyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736AbYHLTyT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 15:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751933AbYHLTyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 15:54:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34368 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751649AbYHLTyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 15:54:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <mjg@redhat.com>
Subject: Re: 2.6.27-rc1: critical thermal shutdown on thinkpad x60
Date: Tue, 12 Aug 2008 21:57:12 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pavel Machek <pavel@suse.cz>, Milan Broz <mbroz@redhat.com>,
       Andi Kleen <andi@firstfloor.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       ACPI mailing list <linux-acpi@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>
References: <20080806090246.GA1572@elf.ucw.cz> <200808121634.34634.rjw@sisk.pl> <20080812153205.GA19070@srcf.ucam.org>
In-Reply-To: <20080812153205.GA19070@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808122157.13423.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 12 of August 2008, Matthew Garrett wrote:
> On Tue, Aug 12, 2008 at 04:34:33PM +0200, Rafael J. Wysocki wrote:
> 
> > Pavel, can you check if the state of the fan(s) change while the thermal trip
> > points are being passed?
> 
> Thinkpads don't expose fans as ACPI devices, so there's no active trip 
> points.

I didn't know that, sorry.
