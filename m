Return-Path: <linux-kernel-owner+w=401wt.eu-S1756133AbXIXVI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133AbXIXVI2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 17:08:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753339AbXIXVIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 17:08:21 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:43029 "EHLO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395AbXIXVIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 17:08:20 -0400
Message-ID: <46F8273B.8030904@aitel.hist.no>
Date: Mon, 24 Sep 2007 23:08:11 +0200
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: x86-64 sporadic hang in  2.6.23rc7 and 2.6.22
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The two kernels mentioned hangs occationally.
Typically when I compile something and pass the time
by surfing the web.

A few minutes and then I notice that the mouse (and everything else in X)
stops.  kbd LEDs does not react to numlock/capslock.
The only thing that still works is sysrq+B
So far this has happened while running X, so no messages.

I have gone back to 2.6.22rc4, which seems to work.

This is a single opteron, although on a dual-slot board.


Helge Hafting
