Return-Path: <linux-kernel-owner+w=401wt.eu-S1762593AbXKHWdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762593AbXKHWdr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 17:33:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756082AbXKHWdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 17:33:36 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52656 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760375AbXKHWdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 17:33:35 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: CSights <csights@fastmail.fm>
Subject: Re: cannot "hibernate" if program being debugged in gdb is paused after SIGABRT in linux 2.6.23 (but can in 2.6.22.7)
Date: Thu, 8 Nov 2007 23:50:51 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org
References: <200710252103.27675.csights@fastmail.fm> <200710281958.57460.rjw@sisk.pl> <200710301034.08268.csights@fastmail.fm>
In-Reply-To: <200710301034.08268.csights@fastmail.fm>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711082350.52010.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 30 of October 2007, CSights wrote:
> >
> > Thanks, I'll try to reproduce the problem here and fix it.
> 
> No really, thank you!

Sorry for the long delay.

Can you please check if you are able to reproduce the problem with 2.6.24-rc2?

Thanks,
Rafael
