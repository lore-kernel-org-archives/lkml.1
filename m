Return-Path: <linux-kernel-owner+w=401wt.eu-S933133AbXIAW1I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933133AbXIAW1I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 18:27:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932195AbXIAW04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 18:26:56 -0400
Received: from ns1.suse.de ([195.135.220.2]:45874 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932183AbXIAW04 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 18:26:56 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] x86/x86-64 PCI domain support
Date: Sun, 2 Sep 2007 00:26:52 +0200
User-Agent: KMail/1.9.6
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20070901143223.GA32216@havoc.gtf.org> <200709020000.03375.ak@suse.de> <46D9E254.6010702@garzik.org>
In-Reply-To: <46D9E254.6010702@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709020026.52725.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > The second function is redundant? 
> 
> No, it's a hook we must implement, when CONFIG_PCI_DOMAINS is enabled.

Then the other function is redundant.

-Andi
