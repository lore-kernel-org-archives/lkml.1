Return-Path: <linux-kernel-owner+w=401wt.eu-S1752704AbXCVXBF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704AbXCVXBF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 19:01:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752775AbXCVXBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 19:01:05 -0400
Received: from de01egw01.freescale.net ([192.88.165.102]:39268 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704AbXCVXBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 19:01:04 -0400
Message-ID: <46030AAD.4030509@freescale.com>
Date: Thu, 22 Mar 2007 18:01:01 -0500
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (Macintosh; U; PPC Mac OS X Mach-O; it; rv:1.8.1) Gecko/20061010 Firefox/2.0 
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Confused about audio drivers - where do I start?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If I were to write a non-USB audio device driver from scratch (for new hardware), what 
interface would I use?  Has ALSA become the official Linux kernel audio subsystem?  Is 
there a specific device driver I should use as a sample?

-- 
Timur Tabi
Linux Kernel Developer @ Freescale
