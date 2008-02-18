Return-Path: <linux-kernel-owner+w=401wt.eu-S1755945AbYBRG6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945AbYBRG6P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 01:58:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752996AbYBRG6B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 01:58:01 -0500
Received: from hapkido.dreamhost.com ([66.33.216.122]:40134 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854AbYBRG6A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 01:58:00 -0500
Date: Mon, 18 Feb 2008 18:02:01 +1100
From: Carlos Eduardo Medaglia Dyonisio <cadu@nerdfeliz.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25-rc2: Reported regressions from 2.6.24
Message-Id: <20080218180201.6b3276d5.cadu@nerdfeliz.com>
In-Reply-To: <200802172304.00322.rjw@sisk.pl>
References: <200802172304.00322.rjw@sisk.pl>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.5; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Feb 2008 23:03:59 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9960
> Subject		: [2.6.25-rc0 System no longer powers off after shutdown
> Submitter	: Frans Pop <elendil@planet.nl>
> Date		: 2008-02-11 16:23
> References	: http://lkml.org/lkml/2008/2/11/198
> Handled-By	: Greg KH <gregkh@suse.de>
> Patch		: http://lkml.org/lkml/2008/2/8/342

This bug is happening here too. I didn´t apply the patch yet (I´ll do it
when I get home), but if cpufreq is disabled, the system powers off
normally.

I´m using Linus´ git tree, commit 1309d4e68497184d2fd87e892ddf14076c2bda98.

Cheers,
Carlos
-- 
Carlos Eduardo Medaglia Dyonisio
cadu@nerdfeliz.com
http://nerdfeliz.com/
