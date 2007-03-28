Return-Path: <linux-kernel-owner+w=401wt.eu-S965705AbXC1ToI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965705AbXC1ToI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 15:44:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752769AbXC1ToI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 15:44:08 -0400
Received: from ns.suse.de ([195.135.220.2]:47139 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752724AbXC1ToF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 15:44:05 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] Add machine_ops interface  to abstract halting and rebooting
Date: Wed, 28 Mar 2007 21:43:52 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Jan Beulich <jbeulich@novell.com>,
       Stephane Eranian <eranian@hpl.hp.com>, Ingo Molnar <mingo@elte.hu>,
       "Randy.Dunlap" <rdunlap@xenotime.net>
References: <46099709.2000304@goop.org> <200703282122.22869.ak@suse.de> <460AC2C6.9040406@goop.org>
In-Reply-To: <460AC2C6.9040406@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703282143.53037.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 March 2007 21:32, Jeremy Fitzhardinge wrote:
> machine_ops is an interface for the machine_* functions defined in
> <linux/reboot.h>.  This is intended to allow hypervisors to intercept
> the reboot process, but it could be used to implement other x86
> subarchtecture reboots.

Both patches added thanks
-Andi
