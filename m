Return-Path: <linux-kernel-owner+w=401wt.eu-S1752788AbZL2V3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788AbZL2V3Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 16:29:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752766AbZL2V3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 16:29:21 -0500
Received: from www17.your-server.de ([213.133.104.17]:43454 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765AbZL2V3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 16:29:14 -0500
X-Greylist: delayed 1533 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Dec 2009 16:29:13 EST
Subject: Re: [Bug #14670] i915: playing video via XVideo extension makes
 the screen flicker
From: Thomas Meyer <thomas@m3y3r.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Eric Anholt <eric@anholt.net>, Jesse Barnes <jbarnes@virtuousgeek.org>
In-Reply-To: <srmJ8vMxKPH.A.2TD.WxhOLB@chimera>
References: <oBElxfTZdhL.A.bx.-vhOLB@chimera>
	 <srmJ8vMxKPH.A.2TD.WxhOLB@chimera>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Dec 2009 22:02:48 +0100
Message-ID: <1262120568.3523.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, den 29.12.2009, 16:28 +0100 schrieb Rafael J. Wysocki:
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14670
> Subject		: i915: playing video via XVideo extension makes the screen flicker
> Submitter	: Thomas Meyer <thomas@m3y3r.de>
> Date		: 2009-11-23 13:15 (37 days old)

Need to boot 2.6.32.2 with "nomodeset" option to make the above bug go
away. Without "nomodeset" option, i.e. the default for intel kms, the
system behaves very strangley/sluggish under 2.6.32.2.

So yes, please still list this bug.


