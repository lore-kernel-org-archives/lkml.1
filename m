Return-Path: <linux-kernel-owner+w=401wt.eu-S1758565AbZFAU3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758565AbZFAU3o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 16:29:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755790AbZFAU3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 16:29:37 -0400
Received: from dallas.jonmasters.org ([72.29.103.172]:34836 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755058AbZFAU3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 16:29:36 -0400
Subject: Re: 2.6.30-rc7-git4: Reported regressions from 2.6.29
From: Jon Masters <jonathan@jonmasters.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Jonathan Corbet <corbet@lwn.net>
In-Reply-To: <4to6E2myxvG.A.muC.aIbIKB@chimera>
References: <4to6E2myxvG.A.muC.aIbIKB@chimera>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Mon, 01 Jun 2009 16:28:37 -0400
Message-Id: <1243888117.31439.18.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-05-30 at 21:29 +0200, Rafael J. Wysocki wrote:

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13325
> Subject		: 2.6.30-rc kills my box hard - and lockdep chains
> Submitter	: Jonathan Corbet <corbet@lwn.net>
> Date		: 2009-05-14 15:49 (17 days old)
> References	: http://marc.info/?l=linux-kernel&m=124231630701394&w=4

Ingo's tree had a fix for this by increasing the lockdep chain size
IIRC. I think it's worth updating the BZ with current info, Jon?

Jon.


