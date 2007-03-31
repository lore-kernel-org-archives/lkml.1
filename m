Return-Path: <linux-kernel-owner+w=401wt.eu-S933193AbXCaAmN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933193AbXCaAmN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 20:42:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933204AbXCaAmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 20:42:13 -0400
Received: from mga01.intel.com ([192.55.52.88]:16626 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933193AbXCaAmM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 20:42:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,355,1170662400"; 
   d="scan'208"; a="222449794:sNHT18119556"
Message-ID: <460DAE62.3030607@intel.com>
Date: Fri, 30 Mar 2007 17:42:10 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Mail/News 1.5.0.10 (X11/20070311)
MIME-Version: 1.0
To: Grant Coady <gcoady.lk@gmail.com>
CC: Oliver Joa <oliver@j-o-a.de>, linux-kernel@vger.kernel.org
Subject: Re: Intel DP965LT Mainboard running?
References: <460D8FCA.2050907@j-o-a.de> <195r03lcafge17t48hpm09g2jhpn1uuus9@4ax.com>
In-Reply-To: <195r03lcafge17t48hpm09g2jhpn1uuus9@4ax.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Coady wrote:
> On Sat, 31 Mar 2007 00:31:38 +0200, Oliver Joa <oliver@j-o-a.de> wrote:
> 
>> Hi,
>>
>> does anyone have a running Intel DP965LT Mainboard? I can not get this 
>> Board running. You can see the Problems in the Thread "Corrupt 
>> XFS-Filesystems on new Hardware and Kernel". Please can you give me a 
>> running Kernel-Config?
> 
> http://bugsplatter.mine.nu/system/dp965lt.html  some notes and gotchas
> http://bugsplatter.mine.nu/test/boxen/silly/    configs and dmesgs
> 
> I've only had reiserfs and ext3 going, not XFS.  

that page mentions that the onboard NIC has problems linking at 100mbit. Have 
you tried debugging the issue with us? If you can, open up a mail to 
e1000-devel@lists.sourceforge.net or file a ticket at e1000.sf.net?!

Cheers,

Auke
