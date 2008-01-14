Return-Path: <linux-kernel-owner+w=401wt.eu-S1751342AbYANTJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751342AbYANTJm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 14:09:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751531AbYANTJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 14:09:21 -0500
Received: from gecko.sbs.de ([194.138.37.40]:19652 "EHLO gecko.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403AbYANTJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 14:09:20 -0500
Message-ID: <478BB35B.9060507@siemens.com>
Date: Mon, 14 Jan 2008 20:09:15 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Jason Wessel <jason.wessel@windriver.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: State of kgdb on x86-64
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,

what is the state of the kgbd git repos? What should work, what might be
broken?

I'm asking as today I tried to get kgdb up and running on a 4-way x86-64
Xeon box with both 2.6.24-rc6 and -rc7. Once kgdb is enabled in .config,
the boot stops early with this panic:

Kernel panic - not syncing: Attempted to kill init!

May I have more success with 2.6.23? Was x86-64 tested and found working
once? I can dig deeper into the above issue, but before starting
blindly, I would like to asses if there could be more issues ahead on
this arch.

Thanks,
Jan

-- 
Siemens AG, Corporate Technology, CT SE 2
Corporate Competence Center Embedded Linux
