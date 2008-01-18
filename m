Return-Path: <linux-kernel-owner+w=401wt.eu-S1761456AbYARNKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761456AbYARNKn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 08:10:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759441AbYARNKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 08:10:35 -0500
Received: from one.firstfloor.org ([213.235.205.2]:57465 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325AbYARNKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 08:10:35 -0500
Date: Fri, 18 Jan 2008 14:13:53 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/2] x86: add is_f00f_bug helper to fault_32|64.c
Message-ID: <20080118131353.GB16459@one.firstfloor.org>
References: <1200610456.5724.41.camel@brick> <p73d4rzbudl.fsf@bingen.suse.de> <20080118090945.GD24337@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080118090945.GD24337@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Almost everything we do prior unification is double the work.

That's not correct in this case as there are no common workarounds for i386 and 
x86-64. 

-Andi
