Return-Path: <linux-kernel-owner+w=401wt.eu-S1753760AbZHIJ5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760AbZHIJ5s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 05:57:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753739AbZHIJ5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 05:57:47 -0400
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:59825 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730AbZHIJ5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 05:57:46 -0400
Message-Id: <20090809095645.198777507@hardeman.nu>
User-Agent: quilt/0.46-1
Date: Sun, 09 Aug 2009 11:56:45 +0200
From: david@hardeman.nu
To: linux-kernel@vger.kernel.org
Cc: linux-input@vger.kernel.org, jbarnes@virtuousgeek.org,
       akpm@linux-foundation.org, bjorn.helgaas@hp.com,
       randy.dunlap@oracle.com, david@hardeman.nu
Subject: [patch 0/2] Winbond IR Driver - v2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a new patch set which should replace all the patches currently in the
-mm tree for the winbond cir driver. The new series incorporate feedback from
Bjorn Helgaas (convert the driver from ACPI to PNP) and Randy Dunlap (Kconfig
fixes).

The IR decoding can still be improved but the driver works for in daily use
decoding RC6 commands, so I believe it is ready to go upstream.

-- 
David Härdeman
