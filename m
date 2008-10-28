Return-Path: <linux-kernel-owner+w=401wt.eu-S1754134AbYJ1PFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134AbYJ1PFb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 11:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752224AbYJ1PFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 11:05:23 -0400
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:3830 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187AbYJ1PFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 11:05:23 -0400
Date: Tue, 28 Oct 2008 16:05:20 +0100
From: Folkert van Heusden <folkert@vanheusden.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6.26] OOPS in elv_next_request
Message-ID: <20081028150518.GH11214@vanheusden.com>
References: <20081027090426.GN8318@vanheusden.com> <a8e1da0810272211s4b145bboef26801c3af0d652@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8e1da0810272211s4b145bboef26801c3af0d652@mail.gmail.com>
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Read-Receipt-To: <folkert@vanheusden.com>
Reply-By: Wed Oct 29 12:57:18 CET 2008
X-Message-Flag: Want to extend your PGP web-of-trust? Coordinate a
	key-signing at www.biglumber.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > [ 4768.720058] ---[ end trace 6a50caff78c47574 ]---
> > [ 4769.658313] Floppy drive(s): fd0 is 1.44M
> > [ 4789.656060] no cont in shutdown!
> 
> Hi, could you try the attached test patch?  sorry for using attachment
> as there's some problem for my mail client to reply.

Will see if I can compile it tonight. Takes a while since it is a
celeroon @ 400MHz :-)


Folkert van Heusden

-- 
www.vanheusden.com/multitail - multitail is tail on steroids. multiple
               windows, filtering, coloring, anything you can think of
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
