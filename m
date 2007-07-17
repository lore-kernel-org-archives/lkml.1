Return-Path: <linux-kernel-owner+w=401wt.eu-S1760460AbXGQAok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760460AbXGQAok (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 20:44:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755714AbXGQAod
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 20:44:33 -0400
Received: from 69-12-177-67.dsl.static.sonic.net ([69.12.177.67]:47331 "EHLO
	orion.sysdev.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755615AbXGQAoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 20:44:32 -0400
X-Greylist: delayed 865 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Jul 2007 20:44:32 EDT
Date: Mon, 16 Jul 2007 16:30:47 -0800
From: Tony Borras <tonyb@sysdev.org>
To: linux-kernel@vger.kernel.org
Cc: tonyb@sysdev.org
Subject: Linux 2.4.35 tree abandoned/delayed?
Message-Id: <20070716163047.55a21e6c.tonyb@sysdev.org>
In-Reply-To: <20070716133025.55327074.tonyb@sysdev.org>
References: <20070716133025.55327074.tonyb@sysdev.org>
Organization: SysDev Inc.
X-Mailer: Sylpheed version 1.0.6 (GTK+ 1.2.10; i686-pc-linux-gnu)
X-Operating-System: Linux-2.6.27-SMP64
X-SlakBoot: SlakbootIBS v11.0.2
User-Agent: Sylpheed/1.0.6
X-Sylpheed-Rules: You Bet
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I did get the current 'pre' set of 2.4.35 (circa early
June) patches and applied to 2.4.34.5.  After fixing a goto
mislable in one of the patches (dont remember if it was one of
the patch-2.4.34.? or patch-2.4.35.pre5), managed to build a
vmlinuz-2.4.35 successfully.

Just wondered whether to expect an abandonded tree, in which
case I will fly with this 2.4.35 build or should wait for its
eventual release.
 
Thanks Greg!
 
Tony Borras


There are 10 types of people in this world, those that read
binary and those who don't!

--
  __      __  _     I N C.               http://www.sysdev.org
/ __|\\// __||  \  __   __          /         tonyb@sysdev.org
\__ \ \/\__ \||)|/ O_)\/ /        \/  System Tools / Utilities
|___/ || ___/|_ /\___|\_/        WIntel / Linux Device Drivers

