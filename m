Return-Path: <linux-kernel-owner+w=401wt.eu-S1753971AbYIYSE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971AbYIYSE5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 14:04:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752957AbYIYSEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 14:04:48 -0400
Received: from styx.suse.cz ([82.119.242.94]:53512 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752921AbYIYSEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 14:04:47 -0400
Date: Thu, 25 Sep 2008 21:01:14 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jonathan Corbet <corbet@lwn.net>
cc: David Miller <davem@davemloft.net>, airlied@gmail.com,
       jeffrey.t.kirsher@intel.com, david.vrabel@csr.com, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       chrisl@vmware.com, jbarnes@virtuousgeek.org, jesse.brandeburg@gmail.com
Subject: Re: [Bug #11382] e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
In-Reply-To: <20080924102730.31ee305a@bike.lwn.net>
Message-ID: <alpine.LNX.1.10.0809252057530.3389@pegasus.suse.cz>
References: <alpine.LNX.1.10.0809240014390.4671@pegasus.suse.cz> <20080923.211215.193696086.davem@davemloft.net> <21d7e9970809232245x6a91c6e2l552ff039d07e2017@mail.gmail.com> <20080924.003638.71148740.davem@davemloft.net>
 <20080924102730.31ee305a@bike.lwn.net>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Sep 2008, Jonathan Corbet wrote:

> A data point, just in case it helps...  I've not had time to update my
> desktop system, so this all-Intel, ICH9, e1000e-based box has been stuck
> at 2.6.27-rc3.  It has rawhide as of shortly after the floodgates
> reopened (but with my own kernel); that means X server 1.5.0 and i810
> 2.4.2-3.

If any of you guys has Lenovo thinkpad (T60p ideally) with 8086:104b 
revision 3 card, could you please send me the respective "ethtool -e" 
dump?

Thanks,

-- 
Jiri Kosina
SUSE Labs
