Return-Path: <linux-kernel-owner+w=401wt.eu-S1756485AbYJGWWB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756485AbYJGWWB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 18:22:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754059AbYJGWVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 18:21:52 -0400
Received: from hpsmtp-eml12.kpnxchange.com ([213.75.38.112]:57752 "EHLO
	hpsmtp-eml12.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753635AbYJGWVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 18:21:52 -0400
From: Frans Pop <elendil@planet.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #11697] CD tray closes spontaneously after opening it
Date: Wed, 8 Oct 2008 00:21:49 +0200
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Kay Sievers" <kay.sievers@vrfy.org>
References: <0pOgGB.A.uLG.E475IB@wind> <yWwteD.A.onG.V475IB@wind>
In-Reply-To: <yWwteD.A.onG.V475IB@wind>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810080021.49838.elendil@planet.nl>
X-OriginalArrivalTime: 07 Oct 2008 22:21:50.0260 (UTC) FILETIME=[17FB7F40:01C928CB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 04 October 2008, Rafael J. Wysocki wrote:
> The following bug entry is on the current list of known regressions
> from 2.6.26.  Please verify if it still should be listed and let me
> know (either way).
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11697
> Subject	: CD tray closes spontaneously after opening it
> Submitter	: Frans Pop <elendil@planet.nl>
> Date		: 2008-09-30 10:47 (5 days old)
> References	: http://marc.info/?l=linux-kernel&m=122277167125264&w=4
> Handled-By	: Kay Sievers <kay.sievers@vrfy.org>

I have not been able to reproduce this recently. I also don't think it's 
really worth tracking this as a regression as there's still a lot of 
uncertainty as to what the cause is.

Cheers,
FJP
