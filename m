Return-Path: <linux-kernel-owner+w=401wt.eu-S1759963AbZEKVoF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759963AbZEKVoF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 17:44:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757321AbZEKVnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 17:43:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51164 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756766AbZEKVnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 17:43:52 -0400
Date: Mon, 11 May 2009 23:43:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 02/18] xen: hook io_apic read/write operations
Message-ID: <20090511214338.GD21232@elte.hu>
References: <1241730883-4917-1-git-send-email-jeremy@goop.org> <1241730883-4917-3-git-send-email-jeremy@goop.org> <20090509084201.GF3656@elte.hu> <20090509084324.GA5158@elte.hu> <4A05A408.3020006@goop.org> <20090511111904.GK4648@elte.hu> <4A086D8C.3060404@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A086D8C.3060404@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> But I do think hooking the io-apic operations makes more sense 
> than any other solution because we explicitly want all the other 
> code above it.

That sounds OK-ish at first sight.

	Ingo
