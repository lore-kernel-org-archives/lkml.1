Return-Path: <linux-kernel-owner+w=401wt.eu-S1753745AbZEQM4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745AbZEQM4f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 08:56:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752456AbZEQM4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 08:56:25 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46825 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382AbZEQM4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 08:56:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Daniel Bierstedt <daniel.bierstedt@gmx.de>
Subject: Re: [Bug #13072] forcedeth seems to switch off eth on shutdown
Date: Sun, 17 May 2009 14:56:39 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc5-rjw; KDE/4.2.2; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <yO1BmxN79sN.A.xAG.8_zDKB@chimera> <pQ9WADCjgyE.A.17G.YA0DKB@chimera> <1242563611.15249.2.camel@laptop.workgroup>
In-Reply-To: <1242563611.15249.2.camel@laptop.workgroup>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905171456.39340.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 17 May 2009, Daniel Bierstedt wrote:
> Hello,
> 
> as I wrote on 26'th of April:
> 
> yes, this bug entry should be listed. This bug prevents people from
> using live-cd's or testing the 2.6.29 (if they know about this bug...).
> 
> Meanwhile I did some tests with knoppix 6 (2.6.28.4) and the
> systemrescue-cd (2.6.27.somewhat). Both could deal with eth0, but the
> physical device remained dead...

Thanks for the update.

Rafael
