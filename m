Return-Path: <linux-kernel-owner+w=401wt.eu-S1756767AbYHVIz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767AbYHVIz5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 04:55:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751801AbYHVIzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 04:55:50 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42441 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550AbYHVIzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 04:55:49 -0400
Date: Fri, 22 Aug 2008 10:55:48 +0200
From: Pavel Machek <pavel@suse.cz>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Max Krasnyanskiy <maxk@qualcomm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: latest -git: hibernate: possible circular locking dependency detected
Message-ID: <20080822085548.GA6542@atrey.karlin.mff.cuni.cz>
References: <19f34abd0808210804y7ee91d1fy12da5ad6f82d2451@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0808210804y7ee91d1fy12da5ad6f82d2451@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!


> I just got this on v2.6.27-rc4 (+ unrelated fix):

Did suspend ever work for you on this machine?
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
