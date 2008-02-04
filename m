Return-Path: <linux-kernel-owner+w=401wt.eu-S1755986AbYBDSZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986AbYBDSZe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 13:25:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753677AbYBDSZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 13:25:25 -0500
Received: from mail.suse.de ([195.135.220.2]:44594 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753420AbYBDSZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 13:25:24 -0500
From: Frank Seidel <fseidel@suse.de>
Organization: SUSE LINUX Products GmbH
To: Philip Langdale <philipl@overt.org>
Subject: Re: [PATCH] mmc: extend ricoh_mmc to support Ricoh RL5c476
Date: Mon, 4 Feb 2008 19:25:20 +0100
User-Agent: KMail/1.9.6 (enterprise 20071221.751182)
Cc: sdhci-devel@list.drzeus.cx, linux-kernel@vger.kernel.org,
       Pierre Ossman <drzeus@drzeus.cx>,
       Andrew de Quincey <adq_dvb@lidskialf.net>
References: <200801311838.24743.fseidel@suse.de> <47A418E0.6040205@overt.org>
In-Reply-To: <47A418E0.6040205@overt.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802041925.21340.fseidel@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Samstag 02 Februar 2008 08:16:48, you (Philip Langdale) wrote:
> Again, thanks a lot for investigating and finding the appropriate magic
> incantations. My main comment is to please base this on top of my suspend/resume
> patch which Pierre said he accepted but which isn't in his tree yet - I guess
> he's busy offline right now - haven't heard from him in a while.

to any reason i had some strange problems applying your patch. But i finally made
it and rebased my patch on top of it.
So, in a few moments i'll sent it here as v2 and also a quilt refreshed version
of yours (just in case also somebody had problems.. ah and i fixed a typo
in your signed-off and added mine).

Thanks,
Frank
