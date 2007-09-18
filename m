Return-Path: <linux-kernel-owner+w=401wt.eu-S1755968AbXIRK7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968AbXIRK7f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 06:59:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755061AbXIRK71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 06:59:27 -0400
Received: from ns1.suse.de ([195.135.220.2]:55630 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754767AbXIRK71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 06:59:27 -0400
From: Andi Kleen <ak@suse.de>
To: virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 3/3] Time to make CONFIG_PARAVIRT non-experimental.
Date: Tue, 18 Sep 2007 12:57:41 +0200
User-Agent: KMail/1.9.1
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Anthony Liguori <aliguori@us.ibm.com>,
       Chris Wright <chrisw@sous-sol.org>
References: <1189747054.7262.34.camel@localhost.localdomain> <1189747124.7262.36.camel@localhost.localdomain> <1189747280.7262.39.camel@localhost.localdomain>
In-Reply-To: <1189747280.7262.39.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709181257.41530.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 September 2007 07:21, Rusty Russell wrote:
> It's pretty widely used,

Is it? By whom?

> and the distributions will turn it on. 

That's no reason to make it default y. Please undo that. default y
is near always a bad idea.

Also I would still consider it experimental.

-Andi
