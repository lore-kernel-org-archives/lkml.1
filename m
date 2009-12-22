Return-Path: <linux-kernel-owner+w=401wt.eu-S1752691AbZLVI51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691AbZLVI51 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 03:57:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752442AbZLVI50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 03:57:26 -0500
Received: from mail.gmx.net ([213.165.64.20]:59555 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752185AbZLVI5Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 03:57:25 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19LGU4qriRLUe8oi99Wtfd6ZHN8qkGf/yk+8NyeyH
	Y623UJEYQ1ZOmp
From: Peter =?utf-8?q?H=C3=BCwe?= <PeterHuewe@gmx.de>
To: Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH 1/6] uwb/i1480: add __init/__exit macros
Date: Tue, 22 Dec 2009 09:57:25 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.27-05415-g69a8594; KDE/4.3.3; x86_64; ; )
Cc: David Vrabel <david.vrabel@csr.com>, Jiri Kosina <trivial@kernel.org>,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1261470431-23642-1-git-send-email-peterhuewe@gmx.de> <1261471904.609.0.camel@localhost.localdomain>
In-Reply-To: <1261471904.609.0.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200912220957.25680.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 22 Dezember 2009 09:51:44 schrieb Marcel Holtmann:
> Hi Peter,
> 
> > Trivial patch which adds the __init/__exit macros to the module_init/
> > module_exit functions of
> >
> > uwb/i1480/i1480-est.c
> >
> > @Jiri: As there is no maintainer, it seems it is up to you to decide :)
> 
> actually David Vrabel is taking care of the UWB subsystem and everything
> related to it.
> 
> Regards
> 
> Marcel
> 

Hmm, okay - thanks for the hint.

Unfortunately get-maintainers.pl did not come up with any one.

Thanks,
Peter
