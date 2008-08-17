Return-Path: <linux-kernel-owner+w=401wt.eu-S1755712AbYHQVZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712AbYHQVZ3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 17:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751661AbYHQVZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 17:25:21 -0400
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:62033 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751454AbYHQVZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 17:25:20 -0400
Message-ID: <48A8973F.1090303@lwfinger.net>
Date: Sun, 17 Aug 2008 16:25:19 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #11228] p54usb broken by commit b19fa1f
References: <DLWXHEp37wB.A.duD.yZzpIB@albercik> <sNRO-BDDjQL.A.1tG.EczpIB@albercik>
In-Reply-To: <sNRO-BDDjQL.A.1tG.EczpIB@albercik>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.26.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11228
> Subject		: p54usb broken by commit b19fa1f
> Submitter	: Larry Finger <Larry.Finger@lwfinger.net>
> Date		: 2008-08-02 3:06 (15 days old)
> References	: http://marc.info/?l=linux-kernel&m=121764647801783&w=4
> Handled-By	: Larry Finger <Larry.Finger@lwfinger.net>
> Patch		: http://marc.info/?l=linux-kernel&m=121779445431434&w=4

The fix was pushed from wireless (Linville) to networks (davem) on 8/17.
