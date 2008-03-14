Return-Path: <linux-kernel-owner+w=401wt.eu-S1758681AbYCNXDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758681AbYCNXDR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 19:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751673AbYCNXDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 19:03:07 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:56888 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634AbYCNXDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 19:03:06 -0400
Subject: Re: [PATCH 0/8] NTP updates
From: john stultz <johnstul@us.ibm.com>
To: zippel@linux-m68k.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080314184001.695807682@linux-m68k.org>
References: <20080314184001.695807682@linux-m68k.org>
Content-Type: text/plain
Date: Fri, 14 Mar 2008 16:03:00 -0700
Message-Id: <1205535780.6122.40.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-03-14 at 19:40 +0100, zippel@linux-m68k.org wrote:
> Hi,
> 
> These patches clean up the NTP code a little and add the remaining user
> space bits from the ntp nanokernel, so that it's e.g. now possible to
> enable the nanosecond resolution, which should be useful to keep time in
> a local network in sync (but it also needs an updated glibc/ntpd first).
> 
> I tried my best to also update the various user space APIs (e.g. compat,
> vsyscall), but it would be great if someone could look over it, in case
> I forgot something.

Hey Roman, 

	BTW, These don't seem to apply to the current -git tree, or Andrew's
-mm. What should I be testing them against?

thanks
-john

