Return-Path: <linux-kernel-owner+w=401wt.eu-S1753177Ab0ACXKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177Ab0ACXKS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 18:10:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753151Ab0ACXKP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 18:10:15 -0500
Received: from khc.piap.pl ([195.187.100.11]:42738 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753089Ab0ACXKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 18:10:14 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Thanasis <thanasis@asyr.hopto.org>
Cc: gentoo-user@lists.gentoo.org, Dirk Heinrichs <dirk.heinrichs@online.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [gentoo-user] RAM installed vs reported
References: <4B3B3043.20400@asyr.hopto.org>
	<200912301208.54359.dirk.heinrichs@online.de>
	<4B3B38F2.6090006@asyr.hopto.org>
	<m3fx6r8a0l.fsf@intrepid.localdomain>
	<4B3CF04E.8070603@asyr.hopto.org>
	<m3vdfmosha.fsf@intrepid.localdomain>
	<4B406CDF.7010301@asyr.hopto.org>
Date: Mon, 04 Jan 2010 00:10:10 +0100
In-Reply-To: <4B406CDF.7010301@asyr.hopto.org> (thanasis@asyr.hopto.org's
	message of "Sun, 03 Jan 2010 12:09:35 +0200")
Message-ID: <m3aawulr8t.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanasis <thanasis@asyr.hopto.org> writes:

> Hmm..., but are EMBEDDED options suitable for a netbook like the A110L ?

This "EMBEDDED" just means "don't touch these unless you really know
what you're doing".

BTW I remember using VMSPLIT 2 GB : 2 GB on server-class machines,
before they were upgraded to x86-64.
-- 
Krzysztof Halasa
