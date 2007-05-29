Return-Path: <linux-kernel-owner+w=401wt.eu-S1751785AbXE2WeB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751785AbXE2WeB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 18:34:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750884AbXE2Wdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 18:33:53 -0400
Received: from main.gmane.org ([80.91.229.2]:49447 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870AbXE2Wdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 18:33:53 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Arkadiusz Mehlich <ris@elsat.net.pl>
Subject: =?utf-8?b?cGF0YV9hbWQ=?= hangs system
Date: Tue, 29 May 2007 22:33:17 +0000 (UTC)
Message-ID: <loom.20070530T002505-935@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 217.173.173.29 (Mozilla/5.0 (X11; U; Linux x86_64; pl; rv:1.8.1.3) Gecko/20070413 Firefox/2.0.0.3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Recently i switched from old ide interface to new libata (pata) interface.
With old drivers all's be ok.

When i switch to new driver (pata_amd on MCP55) my burning software (k3b) totaly
hangs system when i have DVD-R, DVD+R in my drive ... with CD-R, CD-ROM, DVD-ROM
work fine.

System hungs on 'detecting media' stage.

There is workaround or patch to fix this problem ?
Is not k3b problem !

Thanks for reply.

