Return-Path: <linux-kernel-owner+w=401wt.eu-S1755936AbZEJVCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936AbZEJVCp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 17:02:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752275AbZEJVCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 17:02:35 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2444 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbZEJVCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 17:02:35 -0400
Subject: Re: RFC: MAINTAINER email address style?
From: Joe Perches <joe@perches.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Pavel Machek <pavel@ucw.cz>, Andrew Morton <akpm@linux-foundation.org>,
       randy.dunlap@oracle.com, torvalds@linux-foundation.org, akpm@kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090510205326.GA22578@uranus.ravnborg.org>
References: <20090417134711.ba0f03e7.randy.dunlap@oracle.com>
	 <1240003652.31116.44.camel@localhost> <20090407081312.GH1408@ucw.cz>
	 <1240415689.21848.19.camel@localhost>
	 <20090422185916.GA3864@uranus.ravnborg.org>
	 <20090422120510.cc17e470.akpm@linux-foundation.org>
	 <1240430185.21848.103.camel@localhost> <20090422203005.GA467@elf.ucw.cz>
	 <1240557233.6735.240.camel@localhost>
	 <1241987200.3877.9.camel@Joe-AcerAspire>
	 <20090510205326.GA22578@uranus.ravnborg.org>
Content-Type: text/plain
Date: Sun, 10 May 2009 14:00:10 -0700
Message-Id: <1241989210.6711.5.camel@Joe-AcerAspire>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-05-10 at 22:53 +0200, Sam Ravnborg wrote:
> On Sun, May 10, 2009 at 01:26:40PM -0700, Joe Perches wrote:
> > Should names and email addresses in MAINTAINERS be integrated?
> > Should it stay as-is or be changed to:
> > 
> > M: name <email>
> > M: name2 <email2>
> 
> I strongly prefer this style. It fits the way I do
> copy'n'paste of selected email addresses.
> 
> If I want to add Rafael in a Cc: line I have to
> anually add "" to surround his name due to the "J." and I
> have to manually add <>.
> Typing in his email address is a no no - and I can spell
> to Wysovski correct only a few times a day.

Exceeded your quota today already? ;)

Are you saying you prefer:

M:	Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>

or:

M:	Len Brown <len.brown@intel.com>
M:	Pavel Machek <pavel@ucw.cz>
M:	"Rafael J. Wysocki" <rjw@sisk.pl>


