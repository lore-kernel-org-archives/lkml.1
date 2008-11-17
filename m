Return-Path: <linux-kernel-owner+w=401wt.eu-S1753383AbYKQVDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383AbYKQVDw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 16:03:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751700AbYKQVDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 16:03:44 -0500
Received: from eazy.amigager.de ([213.239.192.238]:52711 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbYKQVDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 16:03:43 -0500
Date: Mon, 17 Nov 2008 22:03:37 +0100
From: Tino Keitel <tino.keitel@gmx.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [Bug #11982] Fan level 7 after resume wit 2.6.28-rc3
Message-ID: <20081117210337.GA21036@dose.home.local>
Mail-Followup-To: "Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>
References: <VwdsQNEjR_C.A.CiD.9_FIJB@chimera> <Q7OAnAv0V3D.A.jDF.wAGIJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Q7OAnAv0V3D.A.jDF.wAGIJB@chimera>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 16, 2008 at 17:35:18 +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.27.  Please verify if it still should be listed and let me know
> (either way).

The fix seems to be still missing from HEAD, but I tested it and it
fixed the regression that I noticed.

Regards,
Tino
