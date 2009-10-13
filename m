Return-Path: <linux-kernel-owner+w=401wt.eu-S1760547AbZJMQtG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760547AbZJMQtG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 12:49:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760497AbZJMQtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 12:49:06 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:52976 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752983AbZJMQtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 12:49:04 -0400
Date: Tue, 13 Oct 2009 12:47:45 -0400 (EDT)
From: Tim Abbott <tabbott@ksplice.com>
X-X-Sender: tabbott@dr-wily.mit.edu
To: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
cc: Russell King <rmk+kernel@arm.linux.org.uk>,
       Nelson Elhage <nelhage@ksplice.com>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 2/2] arm: Clean up linker script using new linker
 script macros.
In-Reply-To: <20091013085003.GB3194@pengutronix.de>
Message-ID: <alpine.DEB.1.10.0910131147090.2868@dr-wily.mit.edu>
References: <alpine.DEB.1.10.0910021536510.19358@dr-wily.mit.edu> <1254515567-27110-2-git-send-email-tabbott@ksplice.com> <alpine.DEB.1.10.0910121036130.6253@dr-wily.mit.edu> <20091013085003.GB3194@pengutronix.de>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1257051904-1385987671-1255448830=:2868"
Content-ID: <alpine.DEB.1.10.0910131246320.24111@dr-wily.mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1257051904-1385987671-1255448830=:2868
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <alpine.DEB.1.10.0910131159281.2868@dr-wily.mit.edu>

On Tue, 13 Oct 2009, Uwe Kleine-K=F6nig wrote:

> On Mon, Oct 12, 2009 at 10:41:10AM -0400, Tim Abbott wrote:
> > Can someone with an arm machine test this patch?  I'd really appreciate=
=20
> > it.
> Compiles and is running fine on eco920.

Thanks!

Russell, are you willing to take this patch series for 2.6.32?  It would=20
make life a lot easier for my work on building the kernel with=20
-ffunction-sections -fdata-sections targeted at 2.6.33 if these linker=20
script cleanups for the last couple architectures made it into 2.6.32.

=09-Tim Abbott
---1257051904-1385987671-1255448830=:2868--
