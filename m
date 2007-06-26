Return-Path: <linux-kernel-owner+w=401wt.eu-S1759074AbXFZSzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759074AbXFZSzf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 14:55:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757277AbXFZSz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 14:55:28 -0400
Received: from main.gmane.org ([80.91.229.2]:53975 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757234AbXFZSz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 14:55:27 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Frederik Himpe <fhimpe@telenet.be>
Subject: Re: [2.6.22-rc6] NForce4 soft and hard resetting ports and
 exceptions
Date: Tue, 26 Jun 2007 18:54:37 +0000 (UTC)
Message-ID: <pan.2007.06.26.18.54.37@telenet.be>
References: <pan.2007.06.26.17.45.21@telenet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: d54c1e7e8.access.telenet.be
User-Agent: Pan/0.131 (Ghosts: First Variation)
Cc: linux-ide@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jun 2007 17:45:22 +0000, Frederik Himpe wrote:

> I tried Linux 2.6.22-rc6 on my machine with an Asus A8N-SlI Deluxe
> motherboard (NForce 4 chipset).
> 
> When booting, the system hangs for a long time, but it continues after a
> long wait. I found these kind of errors in the logs afterwards:

[...]

> With Linux 2.6.21 this did not happen.
> 
> config, dmesg and lspci can be found here:
> http://artipc10.vub.ac.be/kernelbug/

After disabling hddtemp and smartd services, these errors do not happen 
anymore.

-- 
Frederik

