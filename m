Return-Path: <linux-kernel-owner+w=401wt.eu-S1762405AbZATWpP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762405AbZATWpP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 17:45:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756581AbZATWo7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 17:44:59 -0500
Received: from mail.deathmatch.net ([70.167.247.36]:2658 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756251AbZATWo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 17:44:59 -0500
Date: Tue, 20 Jan 2009 17:44:22 -0500
From: Bob Copeland <me@bobcopeland.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Sergey S. Kostyliov" <rathamahata@gmail.com>
Subject: Re: [Bug #12490] ath5k related kernel panic in 2.6.29-rc1
Message-ID: <20090120224422.GA25168@hash.localnet>
References: <0GOi9pntEoL.A.iGF.B9QdJB@chimera> <2QN7KFic7LG.A.AaH.p9QdJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2QN7KFic7LG.A.AaH.p9QdJB@chimera>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2009 at 10:32:14PM +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.28.  Please verify if it still should be listed and let me know
> (either way).

Yeah I think it should, though it seems to be a rate controller bug and
not specific to ath5k.

-- 
Bob Copeland %% www.bobcopeland.com

