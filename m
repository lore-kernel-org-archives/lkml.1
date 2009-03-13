Return-Path: <linux-kernel-owner+w=401wt.eu-S1758808AbZCMPIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758808AbZCMPIW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 11:08:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753118AbZCMPIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 11:08:11 -0400
Received: from mailix.iml.umu.se ([130.239.57.131]:37107 "HELO
	mailix.iml.umu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751790AbZCMPIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 11:08:09 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Mar 2009 11:08:08 EDT
Date: Fri, 13 Mar 2009 16:01:19 +0100 (CET)
From: Ralf Nyren <ralf@nyren.net>
X-X-Sender: plumbum@fujje.iml.umu.se
To: linux-kernel@vger.kernel.org
cc: klloyd@sierrawireless.com
Subject: Sierra Wireless (MC8780) HSDPA speed issue
Message-ID: <alpine.DEB.1.10.0903131551310.5791@fujje.iml.umu.se>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a Sierra Wireless MC8780 UMTS card in a Fujitsu S6410 laptop running
kernel 2.6.28.7. In kernel sierra driver v1.3.2.

The card works but speed seems limited to approx 1.0 Mbit/s download using the
linux driver.  Testing the card in Windows XP yields download speeds close to
5.0 Mbit/s.

I recently updated the firmware of the card to support HSDPA/HSUPA. The update
gave the desired result in Windows but not in Linux. The speed improved in
Linux but didn't increase above 1 Mbit/s.

Is there any known driver limitations or is this a configuration issue?

Please let me know if you need any additional information.

Best regards, Ralf
