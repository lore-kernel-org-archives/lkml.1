Return-Path: <linux-kernel-owner+w=401wt.eu-S1755899Ab0A0R5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899Ab0A0R5w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 12:57:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755691Ab0A0R5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 12:57:51 -0500
Received: from outbound-mail-313.bluehost.com ([67.222.54.6]:58242 "HELO
	outbound-mail-313.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755823Ab0A0R5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 12:57:51 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=ryxvaU7yLrAsOG8t8v/JOrvNAkjEV4UjRp0MMCzkuooydZQ1iDfAFcv/XDhhjjYrKsNfTqf5qjDltlMQDjmkkpXQCQ9hDMoDA3qZfsCwAUhjqsHkegmAwaLqt+egZtDi;
Date: Wed, 27 Jan 2010 09:57:34 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Soeren Sonnenburg" <sonne@debian.org>
Subject: Re: [Bug #15043] Display goes off with i915.powersave=1
Message-ID: <20100127095734.6c1afc10@jbarnes-piketon>
In-Reply-To: <hE3x9c-4KZM.A.XwF.VKMXLB@chimera>
References: <md-TZL3UUvL.A.FiE.xJMXLB@chimera>
	<hE3x9c-4KZM.A.XwF.VKMXLB@chimera>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Jan 2010 23:04:37 +0100 (CET)
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.32.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15043
> Subject		: Display goes off with i915.powersave=1
> Submitter	: Soeren Sonnenburg <sonne@debian.org>
> Date		: 2010-01-10 20:09 (15 days old)
> References	: http://marc.info/?l=linux-kernel&m=126315457519505&w=4

If this isn't fixed yet, I hope David's patch fixes it.  See "[Bug
#14897] i915: Commit 0e442c60 causes flickering".

-- 
Jesse Barnes, Intel Open Source Technology Center
