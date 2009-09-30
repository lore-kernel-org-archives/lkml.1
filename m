Return-Path: <linux-kernel-owner+w=401wt.eu-S1754708AbZI3PZP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708AbZI3PZP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 11:25:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754665AbZI3PZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 11:25:14 -0400
Received: from cantor.suse.de ([195.135.220.2]:41566 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754645AbZI3PZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 11:25:13 -0400
Date: Wed, 30 Sep 2009 17:25:16 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Jan Scholz <scholz@fias.uni-frankfurt.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Adrian Ulrich <kernel@blinkenlights.ch>
Subject: Re: [Bug #13935] 2.6.31-rcX breaks Apple MightyMouse (Bluetooth
 version)
In-Reply-To: <878wfwwou8.fsf@scholz.fias.uni-frankfurt.de>
Message-ID: <alpine.LSU.2.00.0909301724040.9280@wotan.suse.de>
References: <AuPdDySr74O.A.5LC.Pj1fKB@chimera> <u1L1PAbl8zG.A.eKD.hj1fKB@chimera> <87hbwewlk4.fsf@scholz.fias.uni-frankfurt.de> <878wfwwou8.fsf@scholz.fias.uni-frankfurt.de>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Sep 2009, Jan Scholz wrote:

> now that the patch "HID: completely remove apple mightymouse from
> blacklist" is merged upstream as
> "42960a13001aa6df52ca9952ce996f94a744ea65" I think it should be merged
> in the v2.6.31-stable series as well.

Agreed. As it didn't have "Cc: stable@kernel.org" in the changelog, it 
will not be picked up automagically. 

Will do.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
