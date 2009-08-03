Return-Path: <linux-kernel-owner+w=401wt.eu-S932256AbZHCUe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932256AbZHCUe0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 16:34:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932147AbZHCUeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 16:34:25 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:56964 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932120AbZHCUeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 16:34:24 -0400
Date: Mon, 3 Aug 2009 13:34:11 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Jean-Luc Coulon <jean.luc.coulon@gmail.com>
Subject: Re: [Bug #13770] System freeze on XFS filesystem recovery on an
 external disk
In-Reply-To: <iZB3Pj-uj3M.A.OpD.ZdgdKB@chimera>
Message-ID: <alpine.DEB.2.01.0908031331190.5831@bogon.housecafe.de>
References: <Su1q3S6JjyO.A.jeB.hcgdKB@chimera> <iZB3Pj-uj3M.A.OpD.ZdgdKB@chimera>
User-Agent: Alpine 2.01 (DEB 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX18TCzMiiEbzQpCikJ0LGrpxPBmd7pV85bs2Zdj
 sHdx0GxV/fijpAjN2grIrnFBL5/Qs7mdljLL+vraaiZn3u07un
 j2TRxfZzDBoYkH4S/E6zw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Aug 2009 at 20:58, Rafael J. Wysocki wrote:
> The following bug entry is on the current list of known regressions
> from 2.6.30.  Please verify if it still should be listed and let me know
> (either way).
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13770
> Subject		: System freeze on XFS filesystem recovery on an external disk
> Submitter	: Jean-Luc Coulon <jean.luc.coulon@gmail.com>
> Date		: 2009-07-14 10:31 (20 days old)

Jean-Luc points out in http://bugzilla.kernel.org/show_bug.cgi?id=13770#c4

  > I thought it was a regression but doing quite intensive tests, I had a
  > problem with 2.6.30 as well and eventually the system was frozen.

So, maybe it can be dropped from the regression list?

@Jean-Luc: did you ask on the XFS list for comments on this?

Christian.
-- 
BOFH excuse #182:

endothermal recalibration
