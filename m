Return-Path: <linux-kernel-owner+w=401wt.eu-S1754600AbYKBTYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600AbYKBTYq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 14:24:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752220AbYKBTYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 14:24:38 -0500
Received: from mail.deathmatch.net ([70.167.247.36]:3074 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbYKBTYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 14:24:37 -0500
Date: Sun, 2 Nov 2008 14:24:14 -0500
From: Bob Copeland <me@bobcopeland.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #11901] ath5k triggers WARN_ON in __ieee80211_rx
Message-ID: <20081102192414.GA6304@hash.localnet>
References: <603i_OdVYPF.A.7_D.mjeDJB@chimera> <wOAXuecskPD.A.HfF.GkeDJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <wOAXuecskPD.A.HfF.GkeDJB@chimera>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 02, 2008 at 05:07:05PM +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.27.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11901
> Subject		: ath5k triggers WARN_ON in __ieee80211_rx
> Submitter	: Bob Copeland <me@bobcopeland.com>
> Date		: 2008-10-30 09:15 (4 days old)

Thanks, I just posted a patch for this here:

http://lkml.org/lkml/2008/11/2/157

-- 
Bob Copeland %% www.bobcopeland.com

