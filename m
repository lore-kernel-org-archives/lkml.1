Return-Path: <linux-kernel-owner+w=401wt.eu-S1752444AbYCJIOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444AbYCJIOW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 04:14:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752012AbYCJIOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 04:14:06 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:35014 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751912AbYCJIOB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 04:14:01 -0400
Date: Mon, 10 Mar 2008 09:11:55 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>
Cc: Nick Piggin <npiggin@suse.de>
Subject: inotify fixes in stable
Message-ID: <20080310091155.02b7fe0e@mjolnir.drzeus.cx>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

I was hoping that the fixes for bug 7785 "BUG: at fs/inotify.c:172 set_dentry_child_flags()" could be added to the stable releases. I'm seeing these quite frequently at customer installations.

The relevant commits are d599e36a9ea85432587f4550acc113cd7549d12a and 0d71bd5993b630a989d15adc2562a9ffe41cd26d. Hopefully these do not depend on other updates. Nick would be the expert on that.

Rgds

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
