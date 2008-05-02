Return-Path: <linux-kernel-owner+w=401wt.eu-S935249AbYEBSWL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935249AbYEBSWL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 14:22:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763275AbYEBSV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 14:21:56 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:28650 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759878AbYEBSV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 14:21:56 -0400
To: "Lee Mathers (TCAFS)" <Lee.Mathers@tcafs.org>
Cc: Russ Dill <russ.dill@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Slow DOWN, please!!!
From: Andi Kleen <andi@firstfloor.org>
References: <20080429.190352.137408408.davem@davemloft.net>
	<alpine.LFD.1.10.0804301127020.2980@woody.linux-foundation.org>
	<4818C0BF.5020002@davidnewall.com>
	<alpine.LFD.1.10.0804301202200.2980@woody.linux-foundation.org>
	<4818C571.8040609@davidnewall.com>
	<alpine.LFD.1.10.0804301223220.2980@woody.linux-foundation.org>
	<481947AF.4090101@davidnewall.com>
	<1209655700.27499.28.camel@localhost>
	<loom.20080501T174627-71@post.gmane.org>
	<1209692875.16523.10.camel@localhost>
	<f9d2a5e10805011954l12b54802t63b9ce0957b6087b@mail.gmail.com>
	<481B50B9.2080000@tcafs.org>
Date: Fri, 02 May 2008 20:21:33 +0200
In-Reply-To: <481B50B9.2080000@tcafs.org> (Lee Mathers's message of "Fri, 02 May 2008 13:34:49 -0400")
Message-ID: <873ap0va6q.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 02 May 2008 18:14:39.0168 (UTC) FILETIME=[62B1F400:01C8AC80]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Lee Mathers (TCAFS)" <Lee.Mathers@tcafs.org> writes:

> to think about your posting before delivering it around the world.
> Not to be rude but do you know how dumb you look right now.  There are
> many programs that while provide detailed memory usage  reports.  That
> would be a first step.

To be fair detailed memory analysis of user space can be tricky,
especially if you consider shared pages etc. And the standard tools for it 
are actually not very good (would be a very interesting area for someone
to work on I think) Still the poster could have done much
more research before ranting, agreed.

-Andi
