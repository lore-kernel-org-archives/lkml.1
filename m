Return-Path: <linux-kernel-owner+w=401wt.eu-S1755368AbZGGLBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368AbZGGLBR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 07:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754352AbZGGLBC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 07:01:02 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60988 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754194AbZGGLBB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 07:01:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alejandro Riveira =?utf-8?q?Fern=C3=A1ndez?= <ariveira@gmail.com>
Subject: Re: [Bug #13362] rt2x00: slow wifi with correct basic rate bitmap
Date: Tue, 7 Jul 2009 13:01:43 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc2-rjw; KDE/4.2.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Chris Wright" <chrisw@sous-sol.org>,
       "Johannes Berg" <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>
References: <tSdKBEwEOhE.A.2wF.s_oUKB@chimera> <bXZeuxPQAWE.A.Nd.YBpUKB@chimera> <20090707120651.063e1b1a@varda>
In-Reply-To: <20090707120651.063e1b1a@varda>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200907071301.43709.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 July 2009, Alejandro Riveira Fernández wrote:
> El Tue,  7 Jul 2009 02:00:38 +0200 (CEST)
> "Rafael J. Wysocki" <rjw@sisk.pl> escribió:
> 
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.29 and 2.6.30.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.29 and 2.6.30.  Please verify if it still should
> > be listed and let me know (either way).
> > 
> 
>  It should be still listed 2.6.30.1 does not fix it. still not tried
> 2.6.31-rc* though.

Thanks for the update.

Best,
Rafael
