Return-Path: <linux-kernel-owner+w=401wt.eu-S1161078AbXBUHhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161078AbXBUHhs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 02:37:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161066AbXBUHhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 02:37:47 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:17515 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161022AbXBUHhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 02:37:46 -0500
Date: Tue, 20 Feb 2007 23:32:47 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Hemminger <shemminger@osdl.org>
Cc: Pavel Machek <pavel@ucw.cz>, James Ketrenos <jketreno@linux.intel.com>,
       netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Subject: Re: iwlwifi warnings
Message-Id: <20070220233247.5d5f76b7.randy.dunlap@oracle.com>
In-Reply-To: <45DBE559.8080903@osdl.org>
References: <45CCE3CA.4050904@linux.intel.com>
	<20070213181313.GA5350@ucw.cz>
	<45D254C6.7050401@linux.intel.com>
	<20070219224432.GD21199@elf.ucw.cz>
	<45DBE559.8080903@osdl.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Feb 2007 22:23:21 -0800 Stephen Hemminger wrote:

> BUilding with sparse shows lots of warnings.
> 
> 
> $ make C=1
> Checking kernel compatibility in:
>     /lib/modules/2.6.20.1/source
>  * Kernel supports required features for 'tip' version.
> Building compatibility version in 'compatible/' directory:
> Copying compatible/ from origin/...done
> make -C /lib/modules/2.6.20.1/build M=/home/shemminger/src/iwlwifi-0.0.8 
> modules

[snip]

Good point(s).  Please try to use Documentation/SubmitChecklist,
as indicated in Andrew's -mm announcements (and copied in my sig below).

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
