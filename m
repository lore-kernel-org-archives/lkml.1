Return-Path: <linux-kernel-owner+w=401wt.eu-S1757917AbYGFOdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757917AbYGFOdW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 10:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756309AbYGFOdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 10:33:15 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:52338 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756162AbYGFOdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 10:33:14 -0400
Subject: Re: [Bug #10861] 2.6.26-rc4-git2 - long pause during boot
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Chris Clayton <chris2553@googlemail.com>,
       Hannes Reinecke <hare@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
In-Reply-To: <uBi7uNfg81L.A.teC.90LcIB@albercik>
References: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik>
	 <uBi7uNfg81L.A.teC.90LcIB@albercik>
Content-Type: text/plain
Date: Sun, 06 Jul 2008 09:33:07 -0500
Message-Id: <1215354787.4197.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-07-06 at 13:45 +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.

Erm, this isn't a kernel regression, it's a udev rule problem.

The rule has been identified and fixed; the reporter confirms it fixes
the problem and the upstream maintainer of udev is putting out a release
with it in ... what more exactly needs to be done?

James


