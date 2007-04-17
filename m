Return-Path: <linux-kernel-owner+w=401wt.eu-S1030788AbXDQS6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030788AbXDQS6X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 14:58:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030844AbXDQS6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 14:58:23 -0400
Received: from outmx013.isp.belgacom.be ([195.238.5.64]:58542 "EHLO
	outmx013.isp.belgacom.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030788AbXDQS6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 14:58:22 -0400
Date: Tue, 17 Apr 2007 20:58:49 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Holger Eiboeck <holger@eiboeck.de>
Subject: RFC: drivers/char/watchdog/pcwd.c + drivers/char/watchdog/pcwd_pci.c
Message-ID: <20070417185849.GA2632@infomag.infomag.iguana.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Would anyone object if we would merge the "full bells and whistles" drivers for
the pcwd isa and pci cards in the kernel tree. (It basically only adds some extra
/proc routines). This would make it easier to maintain the "full bells and whistles"
driver.

Greetings,
Wim.

