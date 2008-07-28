Return-Path: <linux-kernel-owner+w=401wt.eu-S1756356AbYG1WsE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756356AbYG1WsE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 18:48:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752045AbYG1Wrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 18:47:51 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:33801 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751471AbYG1Wru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 18:47:50 -0400
Subject: Re: [resend] [PATCH] Build fallout from scsi merge...
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Sterba <dsterba@suse.cz>, Jiri Kosina <jkosina@suse.cz>,
       linux-net@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Andrew Vasquez <andrew.vasquez@qlogic.com>
In-Reply-To: <20080728223557.GA26416@elte.hu>
References: <1217283104.3503.170.camel@localhost.localdomain>
	 <20080728223557.GA26416@elte.hu>
Content-Type: text/plain
Date: Mon, 28 Jul 2008 17:47:19 -0500
Message-Id: <1217285239.3503.172.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-29 at 00:35 +0200, Ingo Molnar wrote:
> * James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> > There's a brown paper bag compile failure introduced by this patch
> 
> hm, while at it, i still dont see the scsi build fix below upstream. My 
> tests were hit by it too.

It's in linux next ... I was just waiting to see if there's any more
fallout.

James


