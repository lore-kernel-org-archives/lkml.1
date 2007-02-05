Return-Path: <linux-kernel-owner+w=401wt.eu-S1751441AbXBEKbH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751441AbXBEKbH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 05:31:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751446AbXBEKbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 05:31:06 -0500
Received: from colibri.its.uu.se ([130.238.4.154]:47840 "EHLO
	colibri.its.uu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbXBEKbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 05:31:05 -0500
X-Greylist: delayed 1493 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Feb 2007 05:31:05 EST
Message-ID: <45C7018B.2010802@lanil.mine.nu>
Date: Mon, 05 Feb 2007 11:06:03 +0100
From: Christian Axelsson <smiler@lanil.mine.nu>
User-Agent: Thunderbird 1.5.0.9 (X11/20061223)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Where is CONFIG_SUSPEND_SMP hidden?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

I'm trying to enable swsusp on my intel core due laptop but I can't find 
  the SUSPEND_SMP in menuconfig (or anywhere else except in .c-files).
Where is the option hidden and what are the dependencies? I'm using 
kernel 2.6.20, but failed to locate it in 2.6.19 aswell.

--
Christian Axelsson
smiler@lanil.mine.nu
