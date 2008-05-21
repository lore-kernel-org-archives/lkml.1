Return-Path: <linux-kernel-owner+w=401wt.eu-S934655AbYEUNJO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934655AbYEUNJO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 09:09:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765510AbYEUNIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 09:08:41 -0400
Received: from mail.netone.net.tr ([193.192.98.182]:22684 "EHLO
	mail.netone.net.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762781AbYEUNIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 09:08:40 -0400
Message-ID: <48341ED5.7060508@netone.net.tr>
Date: Wed, 21 May 2008 16:08:37 +0300
From: Tarkan Erimer <tarkan@netone.net.tr>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: Suggestion About Kernel Releases
Content-Type: text/plain; charset=ISO-8859-9; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 May 2008 13:06:13.0504 (UTC) FILETIME=[724EF800:01C8BB43]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

After long discussions about kernel release methodology, an idea has 
came to ( Any comments welcomed :-) ) my mind :

-  2 weeks of merge window for each "rc" releases should remain the same .
- When decided the 2.6.xx-rcx is ready to become 2.6.xx, it should be 
2.6.xx-test1 instead of 2.6.xx
- Chris Wright (or whoever will handle these "testX" maintaining) can 
maintain these "testX" releases as like 2.6.x.y maintaining.
- After releasing the "testX" releases, the new kernel release process 
should start.
- When Chris decided it is stable enough, it should release as 2.6.xx 
(stable).
- Of course, 2.6.x.y releases follows then as usually.

Please share your opinions. Thanks :-)

Tarkan
