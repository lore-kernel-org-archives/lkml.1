Return-Path: <linux-kernel-owner+w=401wt.eu-S933863AbXLNT66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933863AbXLNT66 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 14:58:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757817AbXLNT6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 14:58:44 -0500
Received: from [194.117.236.238] ([194.117.236.238]:56107 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S932207AbXLNT6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 14:58:43 -0500
Date: Fri, 14 Dec 2007 21:58:09 +0200
From: Eduard-Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Andi Kleen <andi@firstfloor.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Option to disable AMD C1E (allows dynticks to work)
Message-ID: <20071214215809.3e900554@linux360.ro>
In-Reply-To: <20071214181233.GB16351@one.firstfloor.org>
References: <20071214004442.5f9eba88@linux360.ro>
	<p737ijigr8c.fsf@bingen.suse.de>
	<20071214143941.2c7dcfb4@linux360.ro>
	<20071214101720.GA10981@one.firstfloor.org>
	<20071214154106.4f0b2d8c@linux360.ro>
	<20071214122048.GA12550@one.firstfloor.org>
	<20071214180119.4c492f6c@linux360.ro>
	<alpine.LFD.0.99999.0712141835510.3668@localhost.localdomain>
	<20071214181233.GB16351@one.firstfloor.org>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.14; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thanks to both of you for shedding some light on this matter. I'll look
into HPET-related efforts; it looks like a better solution than my
patch.
