Return-Path: <linux-kernel-owner+w=401wt.eu-S1755980AbZDGHQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980AbZDGHQw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 03:16:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751911AbZDGHQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 03:16:43 -0400
Received: from senator.holtmann.net ([87.106.208.187]:57719 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbZDGHQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 03:16:43 -0400
Subject: Re: [Bug #12871] usb bluetooth crashes system
From: Marcel Holtmann <marcel@holtmann.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Pavel Machek <pavel@ucw.cz>
In-Reply-To: <AsKNxFx2juN.A.dO.aGn2JB@chimera>
References: <n4io5wq70ZO.A.gzG.rFn2JB@chimera>
	 <AsKNxFx2juN.A.dO.aGn2JB@chimera>
Content-Type: text/plain
Date: Tue, 07 Apr 2009 09:16:39 +0200
Message-Id: <1239088599.19390.27.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.28.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12871
> Subject		: usb bluetooth crashes system
> Submitter	: Pavel Machek <pavel@ucw.cz>
> Date		: 2009-03-10 11:23 (28 days old)
> References	: http://marc.info/?l=linux-kernel&m=123668450400940&w=4

please have this re-tested against 2.6.30-rc1 then we can work on
figuring out which patch might have fixed it. I think it is fixed now,
but I could be also wrong here.

Regards

Marcel


