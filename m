Return-Path: <linux-kernel-owner+w=401wt.eu-S1753726AbYCPUCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726AbYCPUCc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 16:02:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752445AbYCPUCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 16:02:24 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:42411 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752440AbYCPUCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 16:02:24 -0400
X-Sasl-enc: NMmAaEjKaySKFJbkBTKK5BXLlCroxSftm8DSY//XOy1f 1205697743
Date: Sun, 16 Mar 2008 17:02:21 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Stefan Bauer <stefan.bauer@cs.tu-chemnitz.de>
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Antonino Daplas <adaplas@pol.net>
Subject: Re: [PATCH] i810fb: Fix console switch regression
Message-ID: <20080316200221.GC31782@khazad-dum.debian.net>
References: <200803161942.24555.stefan.bauer@cs.tu-chemnitz.de> <20080316195722.GB31782@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080316195722.GB31782@khazad-dum.debian.net>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Mar 2008, Henrique de Moraes Holschuh wrote:
> Might I suggest using "((!par->dev_flags) & LOCKUP)"?

Never mind, I read your other post about that line not even making any
sense the way it was written.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
