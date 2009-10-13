Return-Path: <linux-kernel-owner+w=401wt.eu-S934252AbZJMVtu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934252AbZJMVtu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 17:49:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760343AbZJMVtu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 17:49:50 -0400
Received: from lucidpixels.com ([75.144.35.66]:55479 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760276AbZJMVtt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 17:49:49 -0400
Date: Tue, 13 Oct 2009 17:49:12 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: lm-sensors@lm-sensors.org
cc: linux-kernel@vger.kernel.org
Subject: lm-sensors 3.1.1-3 not detecting sensors on Intel DP55KG
 motherboard?
Message-ID: <alpine.DEB.2.00.0910131743530.5034@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

# uname -a
Linux box 2.6.31.3 #2 SMP Wed Oct 14 04:55:36 EDT 2009 x86_64 GNU/Linux

I have a DP55KG motherboard, it says Ibex support was added here:
http://www.lm-sensors.org/changeset/5375

# sensors
No sensors found!
Make sure you loaded all the kernel drivers you need.
Try sensors-detect to find out which these are.

I have all of the modules compiled into the kernel and sensors-detect does 
not find anything.

00:1f.3 SMBus: Intel Corporation Ibex Peak SMBus Controller (rev 05)

Any ideas?

Justin.
