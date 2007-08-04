Return-Path: <linux-kernel-owner+w=401wt.eu-S932789AbXHDWBC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932789AbXHDWBC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 18:01:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765727AbXHDWAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 18:00:52 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50294 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765345AbXHDWAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 18:00:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Meelis Roos <mroos@linux.ee>
Subject: Re: Kconfig: 'SUSPEND_SMP' refers to undefined symbol 'HOTPLUG_CPU'
Date: Sun, 5 Aug 2007 00:10:19 +0200
User-Agent: KMail/1.9.5
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
References: <Pine.SOC.4.64.0708041425020.26419@math.ut.ee>
In-Reply-To: <Pine.SOC.4.64.0708041425020.26419@math.ut.ee>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708050010.19338.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 4 August 2007 13:25, Meelis Roos wrote:
> This is arcch/ppc:
> 
> kernel/power/Kconfig:84:warning: 'select' used by config symbol 'SUSPEND_SMP' refers to undefined symbol 'HOTPLUG_CPU'

May I see .config please?
