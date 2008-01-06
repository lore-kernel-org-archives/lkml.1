Return-Path: <linux-kernel-owner+w=401wt.eu-S1755388AbYAFKG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388AbYAFKG1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 05:06:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752205AbYAFKGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 05:06:20 -0500
Received: from postfix2-g20.free.fr ([212.27.60.43]:60933 "EHLO
	postfix2-g20.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126AbYAFKGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 05:06:19 -0500
Message-ID: <4780A79F.4050001@free.fr>
Date: Sun, 06 Jan 2008 11:04:15 +0100
From: matthieu castet <castet.matthieu@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.11) Gecko/20071119 Iceape/1.1.7 (Debian-1.1.7-1)
MIME-Version: 1.0
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Clocksource tsc unstable after sysrq-t
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am on a 2.6.23.11 on a AMD Athlon(tm) XP 1800+.

When I do a sysrq-t, after the dump of task state (that is quite slow 
because of the vesa console framebuffer), I got the message

"Clocksource tsc unstable (delta = 28115415756 ns)
Time: acpi_pm clocksource has been installed."

Is that normal ?


Matthieu
