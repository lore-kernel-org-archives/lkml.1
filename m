Return-Path: <linux-kernel-owner+w=401wt.eu-S964952AbXBLPAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964952AbXBLPAa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 10:00:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964953AbXBLPAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 10:00:30 -0500
Received: from palakse.guam.net ([202.128.0.38]:39393 "EHLO palakse.guam.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964952AbXBLPA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 10:00:29 -0500
From: "Michael D. Setzer II" <mikes@kuentos.guam.net>
To: linux-kernel@vger.kernel.org
Date: Tue, 13 Feb 2007 01:00:06 +1000
MIME-Version: 1.0
Subject: Using kernel with modules for nics that cause errors.
Message-ID: <45D10D96.14820.3205274@mikes.kuentos.guam.net>
X-mailer: Pegasus Mail for Windows (4.41)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Question on using modules with kernel. 
I've been building the latest git kernels for the G4L project, 
and the latest 
kernels have added support for a lot of newer hardware, but 
currently have 
two of the nic drivers that cause problems when build into 
the kernel. 

DEPCA causes a kernel panic. 
TLAN just stops during the boot. 
Without these, the kernel boots fine. Unfortunately, I don't 
have either of 
these cards, so built it with these as modules, and put the 
.ko files in the 
/lib/modules/2.6.20 directory. Would the instructions for a 
user that does 
have one of these cards just to use insmod? 

I generally have about 9000 downloads per month of the 
project files, so 
would assume that some users would have these cards. 

Thanks. 

+----------------------------------------------------------+
  Michael D. Setzer II -  Computer Science Instructor      
  Guam Community College  Computer Center                  
  mailto:mikes@kuentos.guam.net                            
  mailto:msetzerii@gmail.com
  http://www.guam.net/home/mikes
  Guam - Where America's Day Begins                        
+----------------------------------------------------------+

http://setiathome.berkeley.edu
Number of Seti Units Returned:  19,471
Processing time:  32 years, 290 days, 12 hours, 58 minutes
(Total Hours: 287,489)

BOINC TOTAL CREDITS 
SETI@HOME/EINSTEIN@HOME/ROSETTA@HOME
Total Credits 2732993.968392 
Total Credits 508418.821181 
Total Credits 8288.718734 

