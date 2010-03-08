Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882Ab0CHV7e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 16:59:34 -0500
Received: from ipo3.cc.utah.edu ([155.97.131.71]:44434 "EHLO ipo3.cc.utah.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753798Ab0CHV7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 16:59:30 -0500
X-Greylist: delayed 573 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Mar 2010 16:59:30 EST
X-SBRS: None
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqwSANf/lEubYbWV/2dsb2JhbACTQYdvc6x/AQmER4hZAoJngg8Egxc
X-IronPort-AV: E=Sophos;i="4.49,604,1262588400"; 
   d="scan'208";a="109893317"
Message-ID: <4B957104.8050207@utah.edu>
Date: Mon, 08 Mar 2010 14:49:56 -0700
From: Tom Ammon <tom.ammon@utah.edu>
Organization: University of Utah CHPC
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091204 Lightning/1.0b1 Thunderbird/3.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: ARP cache timeout on various RHELs
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Mar 2010 21:49:57.0098 (UTC) FILETIME=[4B36E4A0:01CABF09]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm trying to figure out how to find and manipulate the ARP cache
timeout on RHEL4 and 5. I know that it's not as simple as one single
timer, but I was hoping somebody here could offer some guidance on how
to get at this info.

I'm also interested, if anybody knows, in how/why the default ARP
behavior changed between RHEL4 and RHEL5.

Tom

-- 
--------------------------------------------------------------------
Tom Ammon
Network Engineer
Office: 801.587.0976
Mobile: 801.674.9273

Center for High Performance Computing
University of Utah
http://www.chpc.utah.edu

