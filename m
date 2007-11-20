Return-Path: <linux-kernel-owner+w=401wt.eu-S1757430AbXKTX0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430AbXKTX0q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 18:26:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752283AbXKTX0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 18:26:35 -0500
Received: from mx1.redhat.com ([66.187.233.31]:55667 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836AbXKTX0e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 18:26:34 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: "Guillaume Chazarain" <guichaz@yahoo.fr>
X-Fcc: ~/Mail/linus
Cc: "Ingo Molnar" <mingo@elte.hu>, "Eric W. Biederman" <ebiederm@xmission.com>,
       "Pavel Emelyanov" <xemul@openvz.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Pavel Machek" <pavel@ucw.cz>,
       "kernel list" <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>, "Ulrich Drepper" <drepper@redhat.com>
Subject: Re: 2.6.24-rc3: find complains about /proc/net
In-Reply-To: Guillaume Chazarain's message of  Wednesday, 21 November 2007 00:06:49 +0100 <3d8471ca0711201506t6b2b88a0h9484f8a40a1f2e40@mail.gmail.com>
References: <20071119191000.GA1560@elf.ucw.cz>
	<200711192304.25087.rjw@sisk.pl>
	<4743026B.2020907@openvz.org>
	<m11wakshyz.fsf@ebiederm.dsl.xmission.com>
	<20071120215914.GE24156@elte.hu>
	<m1ve7wr28z.fsf@ebiederm.dsl.xmission.com>
	<20071120223559.GA6655@elte.hu>
	<20071120225457.B6E2D26F8BE@magilla.localdomain>
	<20071120230106.GD24380@elte.hu>
	<3d8471ca0711201506t6b2b88a0h9484f8a40a1f2e40@mail.gmail.com>
Emacs: the only text editor known to get indigestion.
Message-Id: <20071120232600.F1D2F26F8BE@magilla.localdomain>
Date: Tue, 20 Nov 2007 15:26:00 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oh, it seems it has indeed been that way for a very long time, so I was
mistaken.  It still seems a little odd to me.  Ulrich can say definitively
whether the kind of concern I mentioned really matters one way or the other
for glibc.


Thanks,
Roland
