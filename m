Return-Path: <linux-kernel-owner+w=401wt.eu-S1755817AbXJAP71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755817AbXJAP71 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 11:59:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755928AbXJAP6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 11:58:39 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:34857 "EHLO
	pd4mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755917AbXJAP6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 11:58:37 -0400
Date: Mon, 01 Oct 2007 09:57:27 -0600
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 0/6] Patch series to add of_platform binding to xilinxfb
To: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       akonovalov@ru.mvista.com, linuxppc@ozlabs.org, adaplas@gmail.com
Message-id: <20071001155024.6114.47993.stgit@trillian.cg.shawcable.net>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
User-Agent: StGIT/0.12.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(resend due to mailer issues.  Apologies to anyone receiving this twice)

This patch series reworks the Xilinx framebuffer driver and then adds
an of_platform bus binding.  The of_platform bus binding is needed to use
the driver in arch/powerpc platforms.

Antonino,

Assuming there are no major issues, I'd like to get this patch series
queued up for inclusion in 2.6.24.

Thanks,
g.

--
Grant Likely, B.Sc. P.Eng.
Secret Lab Technologies Ltd.
