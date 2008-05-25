Return-Path: <linux-kernel-owner+w=401wt.eu-S1761283AbYEYLuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761283AbYEYLuw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 07:50:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757228AbYEYLun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 07:50:43 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:46845 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756838AbYEYLun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 07:50:43 -0400
Date: Sun, 25 May 2008 07:50:31 -0400
From: Gene Heskett <gene.heskett@verizon.net>
Subject: Something odd in knail from 3.5.9 on F8
To: kdepim-users@kde.org, linux-kernel@vger.kernel.org
Message-id: <200805250750.31491.gene.heskett@verizon.net>
Organization: Organization? Not detectable
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-disposition: inline
User-Agent: KMail/1.9.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings all;

Yesterday I needed to email a patch file I had just generated to the maintainer 
of the OS for a "legacy" computer, so I fired up the new mail by clicking on 
his name in a previous email, wrote a short msg and tried to attach the patch.  
But regardless of how many times I backed out of the directory & then went back 
in, the directory listing I was being shown was exactly as it had existed about 
36 hours ago.  No new files could be seen.  So I could not attach it, nor 
include it as text in that msg.
.
After I had sent the msg, I shut kmail down using its quit button, gave it 30 
secs to clean up and disappear from the htop list, then restarted it, at which 
point the newer and missing files were then visible and I sent the patch using 
the exact same procedure.

Currently running locally built 2.6.26-rc2 for a kernel.  So which direction do 
I point the accusatory finger here folks?

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
"Prostetnic Vogon Jeltz smiled very slowly. This was done 
not so much for effect as because he was trying to remember 
the sequence of muscle movements. "
