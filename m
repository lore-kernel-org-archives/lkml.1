Return-Path: <linux-kernel-owner+w=401wt.eu-S1755951Ab0A0SCG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951Ab0A0SCG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 13:02:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755926Ab0A0SCE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 13:02:04 -0500
Received: from outbound-mail-158.bluehost.com ([67.222.39.38]:44652 "HELO
	outbound-mail-158.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755212Ab0A0SCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 13:02:01 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=uhJikyR8A5eZ5KlsLENnESzb8ubyhdkVErlFmwyNCn1GjSTyzy1ag1y8tfDFVS58L2qKQXbmNYR/XgY5DrfAVAZIdFaBm3fm5pBoJp2ScyNsAAXCjD9hU4zJ1EVeOidj;
Date: Wed, 27 Jan 2010 10:01:44 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Chris Wilson" <chris@chris-wilson.co.uk>,
       "tomas m" <tmezzadra@gmail.com>
Subject: Re: [Bug #15004] i915: *ERROR* Execbuf while wedged
Message-ID: <20100127100144.4c7d8996@jbarnes-piketon>
In-Reply-To: <q60Z28d_9yH.A.r3H.XZMXLB@chimera>
References: <pYFNu11z2aM.A.pJH.CZMXLB@chimera>
	<q60Z28d_9yH.A.r3H.XZMXLB@chimera>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Jan 2010 23:23:11 +0100 (CET)
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.31 and 2.6.32.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15004
> Subject		: i915: *ERROR* Execbuf while wedged
> Submitter	: tomas m <tmezzadra@gmail.com>
> Date		: 2010-01-07 18:53 (18 days old)

Chris, any ideas about this one?  I remember seeing a few like this
that have been bisected to 2D driver changes recently...

-- 
Jesse Barnes, Intel Open Source Technology Center
