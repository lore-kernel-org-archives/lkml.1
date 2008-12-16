Return-Path: <linux-kernel-owner+w=401wt.eu-S1759467AbYLPP4E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759467AbYLPP4E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 10:56:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759171AbYLPPyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 10:54:31 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55381 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759155AbYLPPya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 10:54:30 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Martin Steigerwald <ms@teamix.de>
Subject: Re: physical memory limit of 64-bit linux
Date: Tue, 16 Dec 2008 16:54:16 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Ingo Molnar <mingo@elte.hu>
References: <200812161556.25518.ms@teamix.de>
In-Reply-To: <200812161556.25518.ms@teamix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812161654.17291.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 16 of December 2008, Martin Steigerwald wrote:
> 
> Hi!
> 
> What is the physical memory limit for 64-bit Linux? I read about 40 bit 
> address bus for AMD Athlon X2 (1 TB) and 48 bit for Barcelona X4 (256 TB).
> 
> Is 64-bit linux able to use that amount - provided that one would manage to 
> build it into a machine? Or does it have a lower limit?
> 
> Looking into the Google crystal ball gives unclear pictures... I tend to 
> assume that Linux would handle it, but I am not sure.

IIRC, the current maximal virtual memory space size of the kernel on x86_64 is 2^46.

Thanks,
Rafael
