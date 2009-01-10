Return-Path: <linux-kernel-owner+w=401wt.eu-S1753706AbZAJTNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706AbZAJTNV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 14:13:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751086AbZAJTNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 14:13:13 -0500
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4366 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbZAJTNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 14:13:12 -0500
Message-ID: <4968F346.8060806@xs4all.nl>
Date: Sat, 10 Jan 2009 20:13:10 +0100
From: Hans de Bruin <bruinjm@xs4all.nl>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Kernelmessage to usbstick?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Would it be possible to send kernel messages to an usbstick? On poweroff 
my laptop displays a kernel trace and a final message:
poweroff[3114] exited with preempt_count 2
/etc/rc.d/rc.0: line 265: 3114 Segementation fault /sbin/poweroff.
I don't have a serial cable within reach, but plenty of usbsticks.

-- 
Hans
