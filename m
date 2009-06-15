Return-Path: <linux-kernel-owner+w=401wt.eu-S1752331AbZFOEGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331AbZFOEGT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 00:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750743AbZFOEGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 00:06:12 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:51138 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbZFOEGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 00:06:11 -0400
X-Greylist: delayed 417 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Jun 2009 00:06:11 EDT
Message-ID: <34989.166.70.238.43.1245035842.squirrel@webmail.wolfmountaingroup.com>
Date: Sun, 14 Jun 2009 21:17:22 -0600 (MDT)
Subject: [ANNOUNCE] ndiswrapper 1.54-2.6.30 posted
From: jmerkey@wolfmountaingroup.com
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The latest ndiswrapper for Linux 2.6.30 has been posted to:


ftp://ftp.wolfmountaingroup.org/pub/ndiswrapper/ndiswrapper-1.54-2.6.30.tar.gz


NOTES:

This build adds support for the newly changed (and apparently on partially
completed) changes for request_irq with the irq_handler_t type which
throws compiler warnings.

I removed the registers being passed on the stack at the end of the isr
routine.  Please let me know if anyone sees problems with this because
other than sucking up extra space, they do not appear to be in use at
present.

Jeffrey Vernon Merkey



