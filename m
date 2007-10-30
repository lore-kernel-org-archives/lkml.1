Return-Path: <linux-kernel-owner+w=401wt.eu-S1756951AbXJ3Rrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756951AbXJ3Rrk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 13:47:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752861AbXJ3Rrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 13:47:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33865 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752395AbXJ3Rrc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 13:47:32 -0400
Date: Tue, 30 Oct 2007 13:47:28 -0400
Message-Id: <200710301747.l9UHlSMH016352@greed.delorie.com>
From: DJ Delorie <dj@redhat.com>
To: dhowells@redhat.com
CC: linux-am33-list@redhat.com, linux-kernel@vger.kernel.org
In-reply-to: <27157.1193763218@redhat.com> (message from David Howells on Tue,
	30 Oct 2007 16:53:38 +0000)
Subject: Re: [Linux-am33-list] [PATCH 0/2] MN10300: Add the MN10300
	architecture to Linux kernel [try #2]
References: <b1c6420f0710300810g1dbf8142j4c515a9baab4207a@mail.gmail.com>
	<20071029122759.2846.83510.stgit@warthog.procyon.org.uk>
	<b1c6420f0710300557j57cfc554m458adc7dbeeed610@mail.gmail.com>
	<15631.1193753689@redhat.com> <27157.1193763218@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> They can if they're told so, plus if they've got the CPU docs to
> hand, it should be more obvious.  The AM33 is a variant of the
> MN10300 arch as far as I can tell.

Right, there's also the AM30, AM31, AM32, and AM34.  Panasonic calls
the whole series the "AM3" or "MN103 series" although they also have
MN103E and MN103S series.  MN103E is the AM33/AM34 microprocessors
(MMU), MN103S is the AM3[012] microcontrollers (no MMU).

http://www.semicon.panasonic.co.jp/e-micom/MicomFamily/roadmap.html
