Return-Path: <linux-kernel-owner+w=401wt.eu-S1756022AbZF2Hn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022AbZF2Hn2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 03:43:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbZF2HnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 03:43:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49731 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751484AbZF2HnU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 03:43:20 -0400
Date: Mon, 29 Jun 2009 09:43:23 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: =?ISO-8859-15?Q?Rub=E9n_A=F3s_Garralda_=3Crubenatch=40gmail=2Ecom=3E?= 
	<rubenatch@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3] Adding rumble support to Thrustmaster Dual Trigger
 3-in-1
In-Reply-To: <alpine.DEB.2.00.0906290926140.9132@localhost>
Message-ID: <alpine.LNX.2.00.0906290943020.18021@wotan.suse.de>
References: <alpine.DEB.2.00.0906290926140.9132@localhost>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="168427776-347786649-1246261403=:18021"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--168427776-347786649-1246261403=:18021
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Mon, 29 Jun 2009, Rubén Aós Garralda <rubenatch@gmail.com> wrote:

> From: Rubén Aós Garralda <rubenatch@gmail.com>
> 
> This patch enables rumble in Thrustmaster Dual 3-in-1 trigger gamepads (in
> both PC and PS3 modes). It uses the same code as Thrustmaster FireStorm Dual
> Power 2, so it only adds new USB IDs to hid-core.c and hid-tmff.c
> 
> Signed-off-by: Rubén Aós Garralda <rubenatch@gmail.com>

Applied, thanks!

-- 
Jiri Kosina
SUSE Labs
--168427776-347786649-1246261403=:18021--
