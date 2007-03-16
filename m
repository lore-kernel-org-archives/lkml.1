Return-Path: <linux-kernel-owner+w=401wt.eu-S2992456AbXCPXww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992456AbXCPXww (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 19:52:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992458AbXCPXww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 19:52:52 -0400
Received: from tabor.taborcommunications.com ([63.240.50.195]:54071 "EHLO
	tabor.taborcommunications.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2992456AbXCPXwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 19:52:51 -0400
X-Greylist: delayed 997 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Mar 2007 19:52:51 EDT
Date: Fri, 16 Mar 2007 16:36:03 -0700 (PDT)
From: Tony Fogle <tony@taborcommunications.com>
To: linux-kernel@vger.kernel.org
Subject: SATA: Marvell 88SE6141 in Asus P5WDG2-WS not recognized
Message-ID: <Pine.LNX.4.62.0703161620240.30578@tabor.taborcommunications.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-tabor-MailScanner-Information: Please contact Systems @ taborcommunications.com for more information
X-tabor-MailScanner: Found to be clean
X-tabor-MailScanner-From: tony@taborcommunications.com
X-tabor-MailScanner-To: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone;

I saw some talk on this mailing list about 9 months ago about the Marvell 
88SE6141 Sata II not being recognized.

I just went from FC5 to a new Fedora Core 6 install, and even updated to 
the latest kernel 2.6.20-1.2925 on an x86_64.

The kernel is not seeing my 2nd set of 4 Sata II ports provided by the 
Marvell chipset.  It doesn't matter if I enable the raid management boot 
prom option or not.

I'm having no problems with the 4 Intel Sata II ports.

Any help would be appreciated.

Thanks,
Tony

