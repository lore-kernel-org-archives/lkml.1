Return-Path: <linux-kernel-owner+w=401wt.eu-S1756744AbZDVUhg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744AbZDVUhg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 16:37:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752824AbZDVUhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 16:37:19 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:3602 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754288AbZDVUhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 16:37:18 -0400
Subject: Re: [PATCH 0/10] MAINTAINERS - add script, patterns and misc
 updates
From: Joe Perches <joe@perches.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Sam Ravnborg <sam@ravnborg.org>,
       randy.dunlap@oracle.com, torvalds@linux-foundation.org, akpm@kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090422203005.GA467@elf.ucw.cz>
References: <1239167872-8179-1-git-send-email-joe@perches.com>
	 <20090417134711.ba0f03e7.randy.dunlap@oracle.com>
	 <1240003652.31116.44.camel@localhost> <20090407081312.GH1408@ucw.cz>
	 <1240415689.21848.19.camel@localhost>
	 <20090422185916.GA3864@uranus.ravnborg.org>
	 <20090422120510.cc17e470.akpm@linux-foundation.org>
	 <1240430185.21848.103.camel@localhost>  <20090422203005.GA467@elf.ucw.cz>
Content-Type: text/plain
Date: Wed, 22 Apr 2009 13:34:25 -0700
Message-Id: <1240432465.21848.108.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2-1.2mdv2009.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-22 at 22:30 +0200, Pavel Machek wrote:
> If possible, it would be nice to aggregate multiple entries onto one
> line. I.e.:
> 
> P:      Len Brown
> M:      len.brown@intel.com
> P:      Pavel Machek
> M:      pavel@ucw.cz
> P:      Rafael J. Wysocki
> M:      rjw@sisk.pl
> L:      linux-pm@lists.linux-foundation.org
> S:      Supported
> 
> ->
> 
> P:      Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Rafael J. Wysocki <rjw@sisk.pl>
> L:      linux-pm@lists.linux-foundation.org
> S:      Supported

I'd prefer the multi-line form as it's more likely
to fit without wrapping on-screen, but I'll do either
if that's the consensus opinion.

There are a couple of entries with commas already
so I'd quote those, so no worries.

Anyone else?

