Return-Path: <linux-kernel-owner+w=401wt.eu-S1758188AbZBTKoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758188AbZBTKoz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 05:44:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755239AbZBTKof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 05:44:35 -0500
Received: from cytosin.uni-konstanz.de ([134.34.240.61]:45669 "EHLO
	cytosin.uni-konstanz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757864AbZBTKoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 05:44:34 -0500
X-Greylist: delayed 623 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Feb 2009 05:44:34 EST
X-IronPort-AV: E=Sophos;i="4.38,240,1233532800"; 
   d="scan'208";a="127864644"
Message-ID: <499E8721.4040005@uni-konstanz.de>
Date: Fri, 20 Feb 2009 11:34:09 +0100
From: Kay Diederichs <kay.diederichs@uni-konstanz.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20090107)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Status of ext4 tools
References: <20090219234838.4c06c98b@werewolf.home> <20090220102200.GJ8921@charite.de>
In-Reply-To: <20090220102200.GJ8921@charite.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ralf Hildebrandt schrieb:
> * J.A. Magallón <jamagallon@ono.com>:
> 
>> - I have seen that some distros refer to a package called 'e4fsprogs'.
>>   Does that thing exist ? Where ?
> 
> RedHat seems to have that, but here on Debian/Ubuntu that doesn't exist.
> 

The release notes say
"Please note that "e4fsprogs" simply contains renamed static binaries
from the equivalent upstream e2fsprogs release; it is packaged this
way for Red Hat Enterprise Linux 5 to ensure that the many changes
included for ext4 do not destabilize the core e2fsprogs in RHEL5."




