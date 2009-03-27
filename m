Return-Path: <linux-kernel-owner+w=401wt.eu-S1760136AbZC0SGE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760136AbZC0SGE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 14:06:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760251AbZC0SFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 14:05:07 -0400
Received: from ara.aytolacoruna.es ([91.117.124.165]:34919 "EHLO
	mx.aytolacoruna.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760234AbZC0SFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 14:05:05 -0400
Date: Fri, 27 Mar 2009 19:04:58 +0100
From: Santiago Garcia Mantinan <manty@manty.net>
To: Frans Pop <elendil@planet.nl>
Cc: Santiago Garcia Mantinan <manty@manty.net>, linux-kernel@vger.kernel.org
Subject: Re: uli526x hangs on 2.6.29, not on rc8
Message-ID: <20090327180458.GA4459@dis.manty.net>
References: <20090326231515.GA6612@dis.manty.net> <200903270102.00104.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903270102.00104.elendil@planet.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Known issue probably. Try: http://lkml.org/lkml/2009/3/25/217

Yes, seems related, I'm testing that patch right now on my machine, but I'm
wondering if I should test that one or this one
(http://www.spinics.net/lists/netdev/msg92829.html) sent also by Herbert to
the netdev list but at a later time.  I'll try test the second one also just
in case.

Regards...
-- 
Manty/BestiaTester -> http://manty.net
