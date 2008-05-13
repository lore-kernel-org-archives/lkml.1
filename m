Return-Path: <linux-kernel-owner+w=401wt.eu-S1759887AbYEMLIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759887AbYEMLIr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 07:08:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753025AbYEMLIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 07:08:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55296 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752812AbYEMLIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 07:08:38 -0400
Date: Tue, 13 May 2008 13:08:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [PATCH] xen: remove support for non-PAE 32-bit
Message-ID: <20080513110822.GA1679@elte.hu>
References: <48243015.2010801@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48243015.2010801@goop.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1178]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Non-PAE operation has been deprecated in Xen for a while, and is 
> rarely tested or used.  xen-unstable has now officially dropped 
> non-PAE support.  Since Xen/pvops' non-PAE support has also been 
> broken for a while, we may as well completely drop it altogether.

applied, thanks.

	Ingo
