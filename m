Return-Path: <linux-kernel-owner+w=401wt.eu-S1759375AbZFBGJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759375AbZFBGJz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 02:09:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757757AbZFBGJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 02:09:47 -0400
Received: from straum.hexapodia.org ([64.81.70.185]:40462 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757709AbZFBGJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 02:09:47 -0400
Date: Mon, 1 Jun 2009 23:09:48 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>
Subject: Re: [Bug #13179] CD-R: wodim intermittent failures
Message-ID: <20090602060948.GY28124@hexapodia.org>
References: <4to6E2myxvG.A.muC.aIbIKB@chimera> <LEcEO2518_I.A.I5E.BKbIKB@chimera> <4A24ADB9.6010903@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A24ADB9.6010903@gmail.com>
User-Agent: Mutt/1.4.2.3i
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 01, 2009 at 10:42:33PM -0600, Robert Hancock wrote:
> Rafael J. Wysocki wrote:
> >This message has been generated automatically as a part of a report
> >of recent regressions.
> >
> >The following bug entry is on the current list of known regressions
> >from 2.6.29.  Please verify if it still should be listed and let me know
> >(either way).
> >
> >
> >Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13179
> >Subject		: CD-R: wodim intermittent failures
> >Submitter	: Andy Isaacson <adi@hexapodia.org>
> >Date		: 2009-04-21 1:52 (40 days old)
> >References	: http://marc.info/?l=linux-kernel&m=124027879214231&w=4
> 
> Last I heard the reporter was going to attempt a bisect, that was a 
> while ago. I don't really have any suggestions other than that.

I've been having trouble reliably bisecting; sometimes seemingly-bad
kernels work OK and other times thought-OK kernels fail even though I've
stopped Gnome and HAL.

At this point I'm suspecting intermittent hardware failure and am
getting set up to test on a similar machine.

-andy
