Return-Path: <linux-kernel-owner+w=401wt.eu-S932279AbXDBFlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932279AbXDBFlg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 01:41:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932309AbXDBFlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 01:41:35 -0400
Received: from sccrmhc15.comcast.net ([63.240.77.85]:36727 "EHLO
	sccrmhc15.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932173AbXDBFld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 01:41:33 -0400
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 12/16] cifs-use-mutex.diff
X-Message-Flag: Warning: May contain useful information
X-Priority: 1
X-MSMail-Priority: High
References: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr>
	<Pine.LNX.4.61.0704012009410.12316@yvahk01.tjqt.qr>
From: Roland Dreier <roland@digitalvampire.org>
Date: Sun, 01 Apr 2007 22:36:48 -0700
In-Reply-To: <Pine.LNX.4.61.0704012009410.12316@yvahk01.tjqt.qr> (Jan
 Engelhardt's message of "Sun, 1 Apr 2007 20:16:49 +0200 (MEST)")
Message-ID: <878xdbnxqn.fsf@digitalvampire.org>
User-Agent: Gnus/5.1006 (Gnus v5.10.6) XEmacs/21.4 (Jumbo Shrimp, linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for resurrecting this.  My original email to the CIFS
maintainer got dropped somewhere, but I think this patch is probably
still a good idea.
-- 
Roland Dreier  <roland@digitalvampire.org>  GPG Key: 1024D/E0EEFAC0
Fingerprint:     A89F B5E9 C185 F34D BD50  4009 37E2 25CC E0EE FAC0

 Sending >500KB attachments is forbidden by the Geneva Convention.
        Your country may be at risk if you fail to comply.
