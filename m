Return-Path: <linux-kernel-owner+w=401wt.eu-S1752592AbYLYTXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592AbYLYTXT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 14:23:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752026AbYLYTXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 14:23:08 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:48800 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012AbYLYTXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 14:23:07 -0500
Date: Thu, 25 Dec 2008 20:22:58 +0100
From: Pavel Machek <pavel@suse.cz>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: linux-kernel@vger.kernel.org, radeonhd@opensuse.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: v2.6.28-rc9: No video with test_suspend=mem
Message-ID: <20081225192258.GB1615@ucw.cz>
References: <1230128020.3455.16.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1230128020.3455.16.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-12-24 15:13:40, Thomas Meyer wrote:
> $ git describe
> v2.6.28-rc9-57-g8960223
> 
> Suspend/resume from S3 seems to work, but I get no video after resume.
> 
> Setting BIOS option "Call Video-BIOS after S3 resume" to "ENABLED" hangs
> the system, so I set it to "DISABLED". The system also hangs after
> resume from S3 by executing program "vbetool post" (entered blindly).

see documentation at suspend.sf.net...

Did the video work after resume in old kernels?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
