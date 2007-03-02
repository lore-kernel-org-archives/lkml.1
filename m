Return-Path: <linux-kernel-owner+w=401wt.eu-S933353AbXCBNOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933353AbXCBNOy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 08:14:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423064AbXCBNOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 08:14:54 -0500
Received: from dtp.xs4all.nl ([80.126.206.180]:12904 "HELO abra2.bitwizard.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S933351AbXCBNOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 08:14:53 -0500
Date: Fri, 2 Mar 2007 14:14:50 +0100
From: Erik Mouw <erik@harddisk-recovery.com>
To: Xavier Callejas <xavier@central.ibcinc.com.sv>
Cc: linux-smp@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: System hanging randomly (SMP Kernel 2.6.20) - ATI chipset+Pentium 4HT
Message-ID: <20070302131449.GA2063@harddisk-recovery.com>
References: <200702281918.01928.xavier@central.ibcinc.com.sv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702281918.01928.xavier@central.ibcinc.com.sv>
Organization: Harddisk-recovery.com
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 28, 2007 at 07:18:01PM -0600, Xavier Callejas wrote:
> I have a laptop Toshiba A70, I attach a DMESG so you know my system.
> 
> The problem is that the system hang randomly and I don't know why, I can se 
> nothing on /var/log/message realted to the hang (I have to force a shutdown 
> first).
> 
> With the NOAPIC option the hang just delay or dismish in frequency. Sometimes 
> the mouse still can move.
> 
> I can't work in my comp. like this, I have posted many messages to suse forum, 
> and other forums but nobody help me. I'm a primary Linux user, I'm a little 
> disapointed because I have not been able to find the solution since monts.

Try to recreate the problem without the proprietary wlan driver. With
that driver loaded it's impossible to debug.


Erik

-- 
+-- Erik Mouw -- www.harddisk-recovery.com -- +31 70 370 12 90 --
| Lab address: Delftechpark 26, 2628 XH, Delft, The Netherlands
