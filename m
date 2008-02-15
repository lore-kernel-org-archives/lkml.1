Return-Path: <linux-kernel-owner+w=401wt.eu-S1759688AbYBOIJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759688AbYBOIJW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 03:09:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751711AbYBOIJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 03:09:15 -0500
Received: from one.firstfloor.org ([213.235.205.2]:52576 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475AbYBOIJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 03:09:15 -0500
Date: Fri, 15 Feb 2008 09:44:57 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, torvalds@osdl.org
Subject: Re: [PATCH] Fix direct mapping alias regressin in ioremap v2
Message-ID: <20080215084457.GA25949@one.firstfloor.org>
References: <20080214165645.GA26748@basil.nowhere.org> <20080214174237.GA24383@elte.hu> <20080214213417.GA19473@one.firstfloor.org> <20080214235652.GA17007@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080214235652.GA17007@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It does not mean they are .26 material (although some of them clearly 

Are the pageattr.c changes in #mm .25 or .26 material? 

-Andi
