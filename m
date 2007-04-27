Return-Path: <linux-kernel-owner+w=401wt.eu-S1757382AbXD0V7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382AbXD0V7i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 17:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757402AbXD0V7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 17:59:37 -0400
Received: from ms-smtp-03.texas.rr.com ([24.93.47.42]:53463 "EHLO
	ms-smtp-03.texas.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757397AbXD0V7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 17:59:34 -0400
From: "Art Haas" <ahaas@airmail.net>
Date: Fri, 27 Apr 2007 16:59:24 -0500
To: linux-kernel@vger.kernel.org
Subject: Re: [patch] CFS scheduler, -v6
Message-ID: <20070427215924.GD2006@artsapartment.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Just wanted to chime and and say that my build of 2.6.21 + CFS-v6 + PI
patch by Thomas Gleixner has been running exceptionally well on my
single processor PII machine (Debian unstable) and my SMP PII machine
(Fedora Rawhide). On both systems no automatic 'renice'-ing happens,
and I've not noticed any performance issues on the Debian box while
in X. The Fedora machine currently runs X only occasionally as most of
the time I use it for building and testing various non-graphical
things.

Art Haas
-- 
Man once surrendering his reason, has no remaining guard against absurdities
the most monstrous, and like a ship without rudder, is the sport of every wind.

-Thomas Jefferson to James Smith, 1822
