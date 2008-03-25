Return-Path: <linux-kernel-owner+w=401wt.eu-S1759355AbYCYS2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759355AbYCYS2S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 14:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757651AbYCYS1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 14:27:53 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:1640 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1757521AbYCYS1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 14:27:53 -0400
Subject: Re: [PATCH 019/148] include/asm-x86/cpufeature.h: checkpatch
	cleanups - formatting only
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20080325153053.GB20898@elte.hu>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
	 <1206259443-13210-20-git-send-email-joe@perches.com>
	 <20080325153053.GB20898@elte.hu>
Content-Type: text/plain
Date: Tue, 25 Mar 2008 11:27:13 -0700
Message-Id: <1206469633.4845.94.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3-1.2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-03-25 at 16:30 +0100, Ingo Molnar wrote:
> > +#define X86_FEATURE_REP_GOOD     _CF(3, 16) /* rep microcode works well
> > +					     * on this CPU */
> that is crap too ...

the _CF or the newly line-broken comment?

