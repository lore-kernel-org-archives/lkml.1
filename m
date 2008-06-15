Return-Path: <linux-kernel-owner+w=401wt.eu-S1758121AbYFOLZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121AbYFOLZw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 07:25:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757516AbYFOLZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 07:25:42 -0400
Received: from hpsmtp-eml11.kpnxchange.com ([213.75.38.111]:58586 "EHLO
	hpsmtp-eml11.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757940AbYFOLZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 07:25:41 -0400
From: Frans Pop <elendil@planet.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Romano Giannetti <romano@dea.icai.upcomillas.es>
Subject: Re: [Bug 10843] Display artifacts on XOrg logout with PAT kernel and VESA framebuffer
Date: Sun, 15 Jun 2008 13:25:38 +0200
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <RzbtSgMztjP.A.R0C.dIDVIB@albercik> <1213525379.15067.3.camel@localhost> <200806151240.53953.rjw@sisk.pl>
In-Reply-To: <200806151240.53953.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806151325.39177.elendil@planet.nl>
X-OriginalArrivalTime: 15 Jun 2008 11:25:40.0023 (UTC) FILETIME=[8A669470:01C8CEDA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 15 June 2008, Rafael J. Wysocki wrote:
> On Sunday, 15 of June 2008, Romano Giannetti wrote:
> > It happens to me too.

Exactly what happens to you to? Do you also see the artifacts?
Do you also use vesafb? Do the artifacts go away if you boot 
with 'video=vfb:off' to disable the framebuffer? Do they go away if you 
compile a kernel without PAT or boot with 'nopat'?

> > Do you see http://bugzilla.kernel.org/show_bug.cgi?id=10892 ?

No. Is that related to PAT being enabled?

> Do these two bug entries refer to the same problem?

Looks unrelated to me.

Cheers,
FJP
