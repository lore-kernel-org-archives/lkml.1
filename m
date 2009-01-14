Return-Path: <linux-kernel-owner+w=401wt.eu-S1759068AbZANHV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759068AbZANHV2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 02:21:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753847AbZANHVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 02:21:18 -0500
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:3129 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754208AbZANHVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 02:21:18 -0500
Subject: Re: [PATCH 0/10] MAINTAINERS - script, patterns, and misc fixes
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, pavel@ucw.cz, linux-kernel@vger.kernel.org
In-Reply-To: <20090113231329.ee0e534f.akpm@linux-foundation.org>
References: <1231878498-25171-1-git-send-email-joe@perches.com>
	 <20090113125435.4821123a.akpm@linux-foundation.org>
	 <1231907210.7935.527.camel@localhost>
	 <20090113231329.ee0e534f.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 13 Jan 2009 23:21:46 -0800
Message-Id: <1231917706.30095.16.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2-1.2mdv2009.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-13 at 23:13 -0800, Andrew Morton wrote:
> > get_maintainer output is in alphabetical order,
> > not ordered by signer frequency.
> The latter would be better?

Maybe.  It's easy enough to change if that's desired.

> I assume there's some remove-akpm rule?  If so, can we please remove
> it?  This tool will be used for bug reports and patches - I want to see
> those emails!

Option: --git-chief-penguins

+push(@penguin_chief,"Linus Torvalds:torvalds\@linux-foundation.org");
+push(@penguin_chief,"Andrew Morton:akpm\@linux-foundation.org");

I'll remove your entry here and just leave Linus.

cheers, Joe

