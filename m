Return-Path: <linux-kernel-owner+w=401wt.eu-S933159AbXD2LCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933159AbXD2LCv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 07:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755130AbXD2LBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 07:01:25 -0400
Received: from cb2.northrockquote.com ([64.251.14.146]:2836 "EHLO
	dejavu.debianpt.org" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755131AbXD2KxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 06:53:04 -0400
X-Greylist: delayed 1508 seconds by postgrey-1.27 at vger.kernel.org; Sun, 29 Apr 2007 06:53:04 EDT
Message-ID: <46347335.7080601@debianpt.org>
Date: Sun, 29 Apr 2007 11:28:05 +0100
From: Miguel Figueiredo <elmig@debianpt.org>
Organization: DebianPT.org
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.21 frozen for a few minutes, swapping to disk
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

today, with 2.6.21, my laptop had a really odd behaviour. It started 
writing to disk for a few minutes with no interactivity at all (no 
redraw on screen, only hdd led on). It's the first time i noticed 
OOM-killer started do kill programs.

It was totally unresponsive for minutes, after back to life it had a 
load of ~19.0, and 300+ MB on swap (first time i saw this).

It's an HP pavillon core duo 2.0 GHz, 1 GB RAM

kern.log details: 
http://www.debianpt.org/~elmig/pool/kernel/20070429/kern.log
.config: http://www.debianpt.org/~elmig/pool/kernel/20070429/2.6.21.config
dmesg: http://www.debianpt.org/~elmig/pool/kernel/20070429/dmesg

As this is the first time it happened and it felt odd i am reporting.

If aditional info is needed please CC me as i am not on the list.

-- 

Com os melhores cumprimentos/Best regards,

Miguel Figueiredo
http://www.DebianPT.org
