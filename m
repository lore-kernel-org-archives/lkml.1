Return-Path: <linux-kernel-owner+w=401wt.eu-S1756905AbYIMHiL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905AbYIMHiL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 03:38:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751368AbYIMHh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 03:37:56 -0400
Received: from hpsmtp-eml14.kpnxchange.com ([213.75.38.114]:55851 "EHLO
	hpsmtp-eml14.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751037AbYIMHhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 03:37:55 -0400
From: Frans Pop <elendil@planet.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #11398] hda_intel: IRQ timing workaround is activated for card #0. Suggest a bigger bdl_pos_adj.
Date: Sat, 13 Sep 2008 09:37:51 +0200
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <j3zWxt-CgYL.A.WTF.bbsyIB@albercik> <SpS7rta8n4.A.z1H.bdsyIB@albercik>
In-Reply-To: <SpS7rta8n4.A.z1H.bdsyIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809130937.52685.elendil@planet.nl>
X-OriginalArrivalTime: 13 Sep 2008 07:37:53.0498 (UTC) FILETIME=[A1B1DBA0:01C91573]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 12 September 2008, Rafael J. Wysocki wrote:
> The following bug entry is on the current list of known regressions
> from 2.6.26.  Please verify if it still should be listed and let me
> know (either way).
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11398
> Subject	: hda_intel: IRQ timing workaround is activated for card #0.
> 		  Suggest a bigger bdl_pos_adj.

Still there.
