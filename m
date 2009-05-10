Return-Path: <linux-kernel-owner+w=401wt.eu-S1755678AbZEJVz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678AbZEJVz1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 17:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752174AbZEJVzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 17:55:15 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2511 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbZEJVzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 17:55:13 -0400
Subject: Re: RFC: MAINTAINER email address style?
From: Joe Perches <joe@perches.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Pavel Machek <pavel@ucw.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, randy.dunlap@oracle.com,
       torvalds@linux-foundation.org, akpm@kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090510222441.0fc3fc5b@lxorguk.ukuu.org.uk>
References: <1239167872-8179-1-git-send-email-joe@perches.com>
	 <20090417134711.ba0f03e7.randy.dunlap@oracle.com>
	 <1240003652.31116.44.camel@localhost> <20090407081312.GH1408@ucw.cz>
	 <1240415689.21848.19.camel@localhost>
	 <20090422185916.GA3864@uranus.ravnborg.org>
	 <20090422120510.cc17e470.akpm@linux-foundation.org>
	 <1240430185.21848.103.camel@localhost> <20090422203005.GA467@elf.ucw.cz>
	 <1240557233.6735.240.camel@localhost>
	 <1241987200.3877.9.camel@Joe-AcerAspire>
	 <20090510222441.0fc3fc5b@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Sun, 10 May 2009 14:52:40 -0700
Message-Id: <1241992360.6711.9.camel@Joe-AcerAspire>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-05-10 at 22:24 +0100, Alan Cox wrote:
> > Should names and email addresses in MAINTAINERS be integrated?
> > Should it stay as-is or be changed to:
> Please leave it alone or it becomes a total PITA to parse.

I think people might parse the integrated style better.

I have a modified version of scripts/get_maintainer.pl
that supports either style.

Are there other scripts that parse MAINTAINERS?


