Return-Path: <linux-kernel-owner+w=401wt.eu-S1751246AbXBVRMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751246AbXBVRMa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 12:12:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751276AbXBVRMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 12:12:30 -0500
Received: from tim.rpsys.net ([194.106.48.114]:53789 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751265AbXBVRM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 12:12:29 -0500
Subject: Re: [PATCH 1/1] PXAFB: Support for backlight control
From: Richard Purdie <rpurdie@rpsys.net>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: Paul Sokolovsky <pmiscml@gmail.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net
In-Reply-To: <20070222163727.GV13924@enneenne.com>
References: <20070221145353.GA23916@enneenne.com>
	 <1056908425.20070221180037@gmail.com> <20070221161210.GL4641@enneenne.com>
	 <1741775233.20070221182608@gmail.com> <20070222083204.GN4641@enneenne.com>
	 <1868738509.20070222123335@gmail.com> <20070222163727.GV13924@enneenne.com>
Content-Type: text/plain
Date: Thu, 22 Feb 2007 17:11:56 +0000
Message-Id: <1172164316.5837.102.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-02-22 at 17:37 +0100, Rodolfo Giometti wrote:
> On Thu, Feb 22, 2007 at 12:33:35PM +0200, Paul Sokolovsky wrote:
> > 
> >   We in handhelds.org codebase have attached patch* to make corgi_bl
> > more suitable for general use. This patch was submitted to Richard
> > (so, more votes needed ;-) ). Otherwise, snippet I pasted is from real
> > machine implementation, HP iPaq h4000.
> 
> You have my vote! :)
> 
> So let me suggest this patch who allows multiple driver instances (I
> use it for both LCD and keypad backlighti devices).
> 
> Hope it could be merged into main line (maybe without the "corgi"
> prefix ;-).

Doing something along these lines is on my todo list but not at the top
since its 2.6.22 material now. Something should appear in -mm within a
few weeks but I don't have the time just at the moment.

Richard


