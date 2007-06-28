Return-Path: <linux-kernel-owner+w=401wt.eu-S1764725AbXF1Md4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764725AbXF1Md4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 08:33:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760569AbXF1Mds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 08:33:48 -0400
Received: from smtp-01b.mandic.com.br ([200.225.81.136]:33026 "EHLO
	smtp-01.mandic.com.br" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760761AbXF1Mds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 08:33:48 -0400
Message-ID: <4683AAA3.9060607@mandic.com.br>
Date: Thu, 28 Jun 2007 09:33:39 -0300
From: "Renato S. Yamane" <renatoyamane@mandic.com.br>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: speedstep-centrino (no such device)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Is impossible use speedstep in my Laptop with Pentium M 1,86Ghz:

#modprobe speedstep-centrino
FATAL: Error inserting speedstep_centrino 
(/lib/modules/2.6.18-3-686/kernel/arch/i386/kernel/cpu/cpufreq/speedstep-centrino.ko): 
No such device

To do that (speedstep), I need install powersaved, but 
speedstep-centrino is not used.

More information can see in:
<https://bugs.launchpad.net/ubuntu/+source/linux-source-2.6.17/+bug/66812>

Regards,
Renato
