Return-Path: <linux-kernel-owner+w=401wt.eu-S1765618AbYBMHXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765618AbYBMHXR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 02:23:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755035AbYBMHXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 02:23:04 -0500
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:4714 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755028AbYBMHXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 02:23:03 -0500
Subject: Re: [GIT PATCH] split up feature-removal-schedule.txt
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>
Cc: gregkh@suse.de, torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080212.230423.172781444.davem@davemloft.net>
References: <20080213070215.GA11969@kroah.com>
	 <20080212.230423.172781444.davem@davemloft.net>
Content-Type: text/plain
Date: Tue, 12 Feb 2008 23:22:02 -0800
Message-Id: <1202887323.3129.10.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-02-12 at 23:04 -0800, David Miller wrote:
> > In the big "linux-next" series of emails, David Miller suggested that
> > the feature-removal-schedule file be broken up into little pieces, as it
> > is causing merge problems for different trees.

I suggest the same for MAINTAINERS

I'd prefer a Maintainers subdirectory.

I have such a tree.  Anyone want it?

