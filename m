Return-Path: <linux-kernel-owner+w=401wt.eu-S1754227AbYHHOuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227AbYHHOuK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 10:50:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752655AbYHHOts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 10:49:48 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:27633 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588AbYHHOtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 10:49:47 -0400
Date: Fri, 8 Aug 2008 16:49:37 +0200
From: Jean Delvare <khali@linux-fr.org>
To: linux-fbdev-devel@lists.sourceforge.net,
       Antonino Daplas <adaplas@gmail.com>
Cc: Petr Vandrovec <vandrove@vc.cvut.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] matroxfb fixes and improvements
Message-ID: <20080808164937.141a95e0@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Antonino,

Not having heard of Petr in one month and a half, I am sending these 3
patches again. Patch 1/3 (matrox maven: Fix a broken error path) in
particular should be applied ASAP. Patch 2/3 (matroxfb: i2c structure
templates clean-up) would be good to have as well and I tested it.
Patch 3/3 (matrox maven: Convert to a new-style i2c driver) needs
testing before it can go upstream. I can't test it myself, but it has
been in linux-next for 6 weeks or so.

Thanks,
-- 
Jean Delvare
