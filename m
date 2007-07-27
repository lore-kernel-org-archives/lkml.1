Return-Path: <linux-kernel-owner+w=401wt.eu-S1763908AbXG0Ac4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763908AbXG0Ac4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 20:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755597AbXG0Act
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 20:32:49 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56528 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755577AbXG0Acs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 20:32:48 -0400
Date: Thu, 26 Jul 2007 17:31:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] MAINTAINERS: use relevant mailing lists
Message-Id: <20070726173140.a76ff4a6.akpm@linux-foundation.org>
In-Reply-To: <20070726170857.dbb42674.randy.dunlap@oracle.com>
References: <20070726170857.dbb42674.randy.dunlap@oracle.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jul 2007 17:08:57 -0700 Randy Dunlap <randy.dunlap@oracle.com> wrote:

> +	Use the relevant mailing list(s) -- don't just send everything to
> +	lkml (linux-kernel@vger.kernel.org).

True.

I personally only troll lkml for unloved patches, so I suspect that a
random patch which is sent to mailing-list-A and not to lkml has a higher
probability of getting lost than one which is sent to both lists.  Plus
it'd be nice to get lkml's patch-to-noise ratio above one percent.

So I'd suggest that you rework the text here to make it clearer that
patches should go to lkml _and_ to the subsystem-specific mailing list.

