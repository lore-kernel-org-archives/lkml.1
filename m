Return-Path: <linux-kernel-owner+w=401wt.eu-S934917AbYBHAAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934917AbYBHAAb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 19:00:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758379AbYBHAAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 19:00:22 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53578 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756846AbYBHAAU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 19:00:20 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Chuck Ebbert <cebbert@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: Re: [PATCH] x86_64: make traps on 'iret' be debuggable in user	space
In-Reply-To: Chuck Ebbert's message of  Thursday, 7 February 2008 18:28:22 -0500 <47AB9416.2030508@redhat.com>
References: <20080205075137.617012701A8@magilla.localdomain>
	<20080205080149.GA16929@elte.hu>
	<20080205081506.655CB2701A8@magilla.localdomain>
	<47AB6652.3010600@redhat.com>
	<20080207203032.5BF392701AB@magilla.localdomain>
	<47AB9416.2030508@redhat.com>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20080208000014.416682701AC@magilla.localdomain>
Date: Thu,  7 Feb 2008 16:00:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It sure didn't look to me like paravirt probably worked.  But what do I know?
