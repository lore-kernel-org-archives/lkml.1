Return-Path: <linux-kernel-owner+w=401wt.eu-S932968AbYBMQTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932968AbYBMQTu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 11:19:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752384AbYBMQTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 11:19:35 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:52248 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763334AbYBMQTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 11:19:32 -0500
Date: Wed, 13 Feb 2008 08:18:32 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Joe Perches <joe@perches.com>
Cc: David Miller <davem@davemloft.net>, gregkh@suse.de,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] split up feature-removal-schedule.txt
Message-Id: <20080213081832.23c0e5dc.randy.dunlap@oracle.com>
In-Reply-To: <1202887323.3129.10.camel@localhost>
References: <20080213070215.GA11969@kroah.com>
	<20080212.230423.172781444.davem@davemloft.net>
	<1202887323.3129.10.camel@localhost>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2008 23:22:02 -0800 Joe Perches wrote:

> On Tue, 2008-02-12 at 23:04 -0800, David Miller wrote:
> > > In the big "linux-next" series of emails, David Miller suggested that
> > > the feature-removal-schedule file be broken up into little pieces, as it
> > > is causing merge problems for different trees.
> 
> I suggest the same for MAINTAINERS
> 
> I'd prefer a Maintainers subdirectory.
> 
> I have such a tree.  Anyone want it?

I'd prefer that neither of them be split up...

The merge problems for either of them should be trivial.

---
~Randy
