Return-Path: <linux-kernel-owner+w=401wt.eu-S1752795AbXCMI2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795AbXCMI2Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 04:28:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753177AbXCMI2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 04:28:24 -0400
Received: from vms048pub.verizon.net ([206.46.252.48]:64887 "EHLO
	vms048pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795AbXCMI2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 04:28:23 -0400
Date: Tue, 13 Mar 2007 04:28:10 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: New thread RDSL, post-2.6.20 kernels and amanda (tar) miss-fires
To: linux-kernel@vger.kernel.org
Message-id: <200703130428.11014.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-disposition: inline
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings;
Someone suggested a fresh thread for this.

I now have my scripts more or less under control, and I can report that 
kernel-2.6.20.1 with no other patches does not exhibit the undesirable 
behaviour where tar thinks its all new, even when told to do a level 2 on 
a directory tree that hasn't been touched in months to update anything.

Next up, 2.6.20.2, plain and with the latest RDSL-0.30 patch.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
> Alan Cox wrote:
[..]

No I didnt.  Someone else wrote that.  Please keep attributions
straight.
	-- From linux-kernel
