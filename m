Return-Path: <linux-kernel-owner+w=401wt.eu-S1754697AbXE2V6I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697AbXE2V6I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 17:58:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754037AbXE2V5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 17:57:50 -0400
Received: from mxfep04.bredband.com ([195.54.107.79]:47066 "EHLO
	mxfep04.bredband.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613AbXE2V5t (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 17:57:49 -0400
Subject: [BUG] Something goes wrong with timer statistics.
From: Ian Kumlien <iank@bredband.net>
To: Linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Tue, 29 May 2007 23:38:48 +0200
Message-Id: <1180474738.22497.25.camel@pi.pomac.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

As the daystar sets, i try to play some with my new would be
firewall/server, but since this will be running for quite some time i
have been experimenting with powertop to find out what i can do to limit
it's power usage.

But, if i run powertop for too long or a few times to many... this
happens:
http://pomac.netswarm.net/pics/kernel_panic.jpg

If i don't run powertop, it is rock solid... Compiling for hours,
running memtest for hours etc etc... 

-- 
Ian Kumlien <pomac () vapor ! com> -- http://pomac.netswarm.net
