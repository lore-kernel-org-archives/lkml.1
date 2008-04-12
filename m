Return-Path: <linux-kernel-owner+w=401wt.eu-S1754789AbYDLQNc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789AbYDLQNc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 12:13:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753123AbYDLQNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 12:13:22 -0400
Received: from main.gmane.org ([80.91.229.2]:41013 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555AbYDLQNV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 12:13:21 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Frederik Himpe <fhimpe@telenet.be>
Subject: Audio skipping with 2.6.24.4 and 2.6.25-rc9
Date: Sat, 12 Apr 2008 16:13:01 +0000 (UTC)
Message-ID: <pan.2008.04.12.16.13.01@telenet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 78-21-61-244.access.telenet.be
User-Agent: Pan/0.132 (Waxed in Black)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm experiencing a lot of problems with audio skipping on my system. I am 
using Rhythmbox as an audio player and have Compiz active. Whenever I 
maximise or restore a maximised real transparent gnome-terminal, audio 
skips. Compared to other normal applications, restoring the transparent 
console is also slow (it takes a few seconds before the window appears).

I ran cfs-debug-info-clear.sh, and the reproduced the problem 3 times by 
restoring and minimising a gnome-terminal window. After that I ran cfs-
debug-info.sh, and I uploaded the information here: 
http://artipc10.vub.ac.be/cfs-debug-info-2008.04.12-18.00.20.gz

This problem happens with both 2.6.24.4 as with 2.6.25-rc9 (the debugging 
information is from the latter version).

-- 
Frederik Himpe

