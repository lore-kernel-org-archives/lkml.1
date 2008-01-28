Return-Path: <linux-kernel-owner+w=401wt.eu-S1763838AbYA1Xdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763838AbYA1Xdr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 18:33:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751684AbYA1Xdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 18:33:38 -0500
Received: from ara.aytolacoruna.es ([91.117.124.165]:56699 "EHLO
	mx.aytolacoruna.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbYA1Xdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 18:33:37 -0500
Date: Tue, 29 Jan 2008 00:33:34 +0100
From: Santiago Garcia Mantinan <manty@manty.net>
To: linux-kernel@vger.kernel.org
Subject: Re: dl2k stopped working on 2.6.24
Message-ID: <20080128233334.GA14326@dis.manty.net>
References: <20080125211153.GA10203@dis.manty.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080125211153.GA10203@dis.manty.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I've been playing with ethtools and got it to work at 100FD by setting it
> manually, but if afterwards I set it to auto it again goes 1000 HD and thus
> not working again.

I have changed my gigabit switch for a 100Mb wrt and the dl2k sets the link
right at 100FD and works much better than when using it at the forced 100FD
on the gigabit switch, in this last configuration the card was strugling a
lot, with tranfers under the megabyte/s.

I don't believe this is anything on my side as the e1000 cards and Nforce4
forcedeth I have all work ok at 1000FD with 2.4.24. Besides, the dl2k works
ok on the same environment with 2.4.23.

If there is a better list or anybody to contact about the dl2k so that I can
send this info please let me know.

As I said on my previous mail, if any other info is needed or testing any
special stuff, don't hesitate to ask.

Regards...
-- 
Manty/BestiaTester -> http://manty.net
