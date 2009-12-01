Return-Path: <linux-kernel-owner+w=401wt.eu-S1752929AbZLAVqO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929AbZLAVqO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 16:46:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752430AbZLAVqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 16:46:13 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:46689 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752373AbZLAVqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 16:46:12 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Lior Dotan <liodot@gmail.com>
Subject: Re: Linux 2.6.32-rc8 - T500 fails to suspend to RAM
Date: Tue, 1 Dec 2009 22:46:58 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rc8-rjw; KDE/4.3.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <4B151FE2.3090807@gmail.com>
In-Reply-To: <4B151FE2.3090807@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912012246.58383.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 December 2009, Lior Dotan wrote:
> Hi,
> 
> Ever since I've upgraded to rc8, my T500 fails to suspend to RAM for the
> second time. Suspending for the first time works ok but when I resume and
> later try to suspend again the screen gets blank and the moon LED blinks
> forever. rc6 & rc7 as well as 2.6.31 worked great with out a problem.

Well, I don't see any particular change that might cause the symptoms you
describe between -rc7 and -rc8.  If this is 100% reproducible, I guess
bisecting is the only option at the moment.

Thanks,
Rafael
