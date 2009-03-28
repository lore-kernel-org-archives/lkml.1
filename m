Return-Path: <linux-kernel-owner+w=401wt.eu-S1755984AbZC1RTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984AbZC1RTq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 13:19:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753291AbZC1RTh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 13:19:37 -0400
Received: from smtp-01.oit.duke.edu ([152.3.174.14]:53885 "EHLO smtp.duke.edu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753024AbZC1RTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 13:19:37 -0400
X-Greylist: delayed 753 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Mar 2009 13:19:36 EDT
Date: Sat, 28 Mar 2009 13:07:04 -0400 (EDT)
From: Rann Bar-On <rb6@duke.edu>
X-X-Sender: rann@localhost
Reply-To: rb6@duke.edu
To: linux-kernel@vger.kernel.org
Subject: [drm:drm_wait_vblank] *ERROR* failed to acquire vblank counter, -22
 message flood
Message-ID: <alpine.LNX.2.00.0903281304450.5692@localhost>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
X-PMX-Version: 5.4.2.338381, Antispam-Engine: 2.6.0.325393, Antispam-Data: 2009.3.28.165225
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

with latest intel drivers, latest mesa, xorg-server 1.6 and kernel 2.6.29 
with kms enabled, I get floods of

[drm:drm_wait_vblank] *ERROR* failed to acquire vblank counter, -22

messages in dmesg.  Using the latest drm-next tree doesn't help either. 
There are some issues with jumpy screens in kde that may be related.

Please help!  Also, please cc me personally, as I am not on the list.

Thanks,
Rann Bar-On
