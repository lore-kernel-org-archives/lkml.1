Return-Path: <linux-kernel-owner+w=401wt.eu-S1755445AbZFEW6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445AbZFEW6S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 18:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752106AbZFEW6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 18:58:10 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4609 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702AbZFEW6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 18:58:09 -0400
Subject: Re: Script to integrate MAINTAINERS P: and M: lines
From: Joe Perches <joe@perches.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090605214715.GE29008@uranus.ravnborg.org>
References: <cover.1243131992.git.joe@perches.com>
	 <136e58c251157179f19a7eecedd1e6fe71a3e6d9.1243131992.git.joe@perches.com>
	 <20090526144141.570594cf.akpm@linux-foundation.org>
	 <1243455722.27337.65.camel@Joe-Laptop.home>
	 <20090527151510.fb773db6.akpm@linux-foundation.org>
	 <1243878331.3402.52.camel@Joe-Laptop.home>
	 <20090605214715.GE29008@uranus.ravnborg.org>
Content-Type: text/plain
Date: Fri, 05 Jun 2009 15:57:25 -0700
Message-Id: <1244242645.3631.172.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-05 at 23:47 +0200, Sam Ravnborg wrote:
> Linus - assuming this script works as advertised I would be glad to see it run.
> It is irritating when copying from MAINTAINERS that it is a
> three step process to copy a single mail address for a Cc: line.

There are a dozen or so patches to scripts/get_maintainer.pl
and MAINTAINERS in Andrew's MM tree that ideally would be
applied before the script was run.


