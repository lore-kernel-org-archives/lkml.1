Return-Path: <linux-kernel-owner+w=401wt.eu-S1755164AbYILKJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164AbYILKJz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 06:09:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752771AbYILKJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 06:09:45 -0400
Received: from cpsmtpo-eml02.kpnxchange.com ([213.75.38.151]:24692 "EHLO
	cpsmtpo-eml02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752477AbYILKJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 06:09:45 -0400
From: Frans Pop <elendil@planet.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #11507] usb: sometimes dead keyboard after boot
Date: Fri, 12 Sep 2008 12:09:41 +0200
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <s3QDdfEDq6.A.wlH.MowwIB@albercik> <Wz8EH5sroeE.A.R0H.WowwIB@albercik>
In-Reply-To: <Wz8EH5sroeE.A.R0H.WowwIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809121209.42354.elendil@planet.nl>
X-OriginalArrivalTime: 12 Sep 2008 10:09:42.0820 (UTC) FILETIME=[ACDC5640:01C914BF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 06 September 2008, Rafael J. Wysocki wrote:
> The following bug entry is on the current list of known regressions
> from 2.6.26.  Please verify if it still should be listed and let me
> know (either way).
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11507
> Subject	: usb: sometimes dead keyboard after boot
> Submitter	: Frans Pop <elendil@planet.nl>
> Date		: 2008-08-26 21:03 (12 days old)
> References	: http://marc.info/?l=linux-kernel&m=121977815018224&w=2

Still there. Alan Stern has provided a patch for the issue:
http://www.spinics.net/lists/linux-usb/msg09735.html

I've just reported back the test results:
http://www.spinics.net/lists/linux-usb/msg09926.html
