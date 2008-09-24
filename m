Return-Path: <linux-kernel-owner+w=401wt.eu-S1754220AbYIXQ1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220AbYIXQ1n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 12:27:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752231AbYIXQ1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 12:27:34 -0400
Received: from vena.lwn.net ([206.168.112.25]:35422 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635AbYIXQ1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 12:27:33 -0400
Date: Wed, 24 Sep 2008 10:27:30 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: David Miller <davem@davemloft.net>
Cc: airlied@gmail.com, jkosina@suse.cz, jeffrey.t.kirsher@intel.com,
       david.vrabel@csr.com, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, chrisl@vmware.com
Subject: Re: [Bug #11382] e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
Message-ID: <20080924102730.31ee305a@bike.lwn.net>
In-Reply-To: <20080924.003638.71148740.davem@davemloft.net>
References: <alpine.LNX.1.10.0809240014390.4671@pegasus.suse.cz>
	<20080923.211215.193696086.davem@davemloft.net>
	<21d7e9970809232245x6a91c6e2l552ff039d07e2017@mail.gmail.com>
	<20080924.003638.71148740.davem@davemloft.net>
Organization: LWN.net
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Sep 2008 00:36:38 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> I'm about to leave for a week or so in Paris for the netfilter
> workshop, so I hope that someone other than myself will do some data
> mining like I have instead of (merely) tossing theories around and
> finger pointing.

A data point, just in case it helps...  I've not had time to update my
desktop system, so this all-Intel, ICH9, e1000e-based box has been stuck
at 2.6.27-rc3.  It has rawhide as of shortly after the floodgates
reopened (but with my own kernel); that means X server 1.5.0 and i810
2.4.2-3.

It's happy as a clam. I'm not sure how often this problem bites, but it
hasn't gotten me.

jon
