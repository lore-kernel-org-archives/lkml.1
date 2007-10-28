Return-Path: <linux-kernel-owner+w=401wt.eu-S1756919AbXJ1Smj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919AbXJ1Smj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 14:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752805AbXJ1Smb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 14:42:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60065 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570AbXJ1Sma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 14:42:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: C Sights <csights@fastmail.fm>
Subject: Re: cannot "hibernate" if program being debugged in gdb is paused after SIGABRT in linux 2.6.23 (but can in 2.6.22.7)
Date: Sun, 28 Oct 2007 19:58:57 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <200710252103.27675.csights@fastmail.fm> <200710270138.15982.rjw@sisk.pl> <200710281133.36995.csights@fastmail.fm>
In-Reply-To: <200710281133.36995.csights@fastmail.fm>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710281958.57460.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 28 October 2007 16:33, C Sights wrote:
> >
> > Well, a test program that triggers the SIGABRT under gdb would be useful.
> 
> The attached program causes a SIGABRT for me,
> 
> Thanks,
> 	C.

Thanks, I'll try to reproduce the problem here and fix it.

Greetings,
Rafael
