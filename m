Return-Path: <linux-kernel-owner+w=401wt.eu-S1764294AbXF1NFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764294AbXF1NFS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 09:05:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760705AbXF1NFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 09:05:08 -0400
Received: from mg.nix.la ([75.126.232.227]:38052 "EHLO mg.nix.la"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759652AbXF1NFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 09:05:07 -0400
X-Greylist: delayed 1374 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Jun 2007 09:05:07 EDT
From: Anton Petrusevich <casus@casus.us>
To: linux-kernel@vger.kernel.org
Subject: Is it time for remove (crap) ALSA from kernel tree ?
Date: Thu, 28 Jun 2007 14:42:04 +0200
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706281442.05239.casus@casus.us>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>>I don't like random applications blocking my sound card. 
>So don't use random applications.
 
I have ICE1724, a very good sound card to my taste, works like a charm. But 
with ALSA I had a really hard time to configure it properly, wanna see 
my .asoundrc? And I am not sure I have done it right (== the best possible 
way). I have read everything on http://www.alsa-project.org/documentation.php 
about .asoundrc. When I am using Skype I have to rename .asoundrc to 
something else in order to get it working. When I am doing some changes 
to .asoundrc I have to restart the app. Is there a tool which can be used to 
configure .asoundrc? I want to be able to hear sound from flashplayer on my 
reciever or in my headphones -- how? It's not quite clear to me how to get 
full duplex working with my .asoundrc.
-- 
Anton Petrusevich
