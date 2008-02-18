Return-Path: <linux-kernel-owner+w=401wt.eu-S1759572AbYBRL3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759572AbYBRL3b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 06:29:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758672AbYBRL3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 06:29:16 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42431 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758386AbYBRL3P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 06:29:15 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Carlos Eduardo Medaglia Dyonisio <cadu@nerdfeliz.com>
Subject: Re: 2.6.25-rc2: Reported regressions from 2.6.24
Date: Mon, 18 Feb 2008 12:27:27 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: LKML <linux-kernel@vger.kernel.org>
References: <200802172304.00322.rjw@sisk.pl> <20080218180201.6b3276d5.cadu@nerdfeliz.com>
In-Reply-To: <20080218180201.6b3276d5.cadu@nerdfeliz.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200802181227.28238.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 18 of February 2008, Carlos Eduardo Medaglia Dyonisio wrote:
> On Sun, 17 Feb 2008 23:03:59 +0100
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9960
> > Subject		: [2.6.25-rc0 System no longer powers off after shutdown
> > Submitter	: Frans Pop <elendil@planet.nl>
> > Date		: 2008-02-11 16:23
> > References	: http://lkml.org/lkml/2008/2/11/198
> > Handled-By	: Greg KH <gregkh@suse.de>
> > Patch		: http://lkml.org/lkml/2008/2/8/342
> 
> This bug is happening here too. I didn´t apply the patch yet (I´ll do it
> when I get home), but if cpufreq is disabled, the system powers off
> normally.
> 
> I´m using Linus´ git tree, commit 1309d4e68497184d2fd87e892ddf14076c2bda98.

Have you tried to apply the patch listed?

Rafael
