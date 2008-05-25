Return-Path: <linux-kernel-owner+w=401wt.eu-S1757887AbYEYSPN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757887AbYEYSPN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 14:15:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754776AbYEYSO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 14:14:59 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:49082 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754491AbYEYSO6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 14:14:58 -0400
Date: Sun, 25 May 2008 20:15:38 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [Bug #10717] crossbuild fails in modpost
Message-ID: <20080525181538.GA7989@uranus.ravnborg.org>
References: <1NnHL0AVfcI.A.hJC.ZdIOIB@albercik> <TW_YzGo9TFP.A.J0D.oeIOIB@albercik>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <TW_YzGo9TFP.A.J0D.oeIOIB@albercik>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 24, 2008 at 10:31:39PM +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.

It was not a regression anyway.

Jiri already commented:
=====
It turned out to be a real bug, which caused failing build. Fixed by
http://lkml.org/lkml/2008/5/19/203
and included also in hid patches in
http://lkml.org/lkml/2008/5/19/223

Sorry for the noise.
=====

I will close it.

	Sam
