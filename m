Return-Path: <linux-kernel-owner+w=401wt.eu-S1755039AbZLDAPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755039AbZLDAPZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 19:15:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754511AbZLDAPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 19:15:24 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41298 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753564AbZLDAPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 19:15:23 -0500
Date: Fri, 4 Dec 2009 00:17:11 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Jeff Garzik <jeff@garzik.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/86] PATA fixes
Message-ID: <20091204001711.2c2af9cc@lxorguk.ukuu.org.uk>
In-Reply-To: <4B18357E.9050900@ru.mvista.com>
References: <20091125170218.5446.13513.sendpatchset@localhost>
	<200912031339.14440.bzolnier@gmail.com>
	<4B17FB37.2030501@garzik.org>
	<200912032045.48728.bzolnier@gmail.com>
	<4B182A9F.5090708@garzik.org>
	<4B18357E.9050900@ru.mvista.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Likewise I'm happy with all of this stuff. My worry is the turn 32bit on
for hardware without real testing/docs checking except where it was on by
default bits.

The rest is good stuff. The 32bit stuff for the unproven cards could do
longer in -next as its only a performance boost for PIO.
