Return-Path: <linux-kernel-owner+w=401wt.eu-S1756909AbZCJWPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909AbZCJWPn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 18:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755431AbZCJWPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 18:15:34 -0400
Received: from adsl19-246.ath.forthnet.gr ([77.49.210.246]:49986 "EHLO
	vergina.dyndns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754920AbZCJWPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 18:15:33 -0400
X-Greylist: delayed 572 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Mar 2009 18:15:32 EDT
Message-ID: <49B6E443.6060205@asyr.hopto.org>
Date: Wed, 11 Mar 2009 00:05:55 +0200
From: Thanasis <thanasis@asyr.hopto.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090307)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: jffs2 and kernel config for SDHC Memory Cards
References: <49B127AB.6070202@asyr.hopto.org> <49B12B71.7030300@asyr.hopto.org> <20090306182425.GB28349@silver.sucs.org> <49B18679.4030504@asyr.hopto.org> <20090306225746.GB25593@silver.sucs.org> <49B2A7F0.1090101@asyr.hopto.org> <20090310112355.GF1337@ucw.cz>
In-Reply-To: <20090310112355.GF1337@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-7
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on 03/10/2009 01:23 PM Pavel Machek wrote the following:

> Well, maybe  ext2 is _best_ choice, but it is not good one. It will
> loose data on sudden powerdowns...
> 
> See
> 
> (english) http://www.livejournal.com/~pavelmachek
> 
> entry 'evil little cards'.

My problem is not a sudden power failure, which is unlikely, because
it's a netbook with the battery always on, but from accidentally
ejecting the one card that protrudes on the right hand side (the other
on the left side doesn't). I have already done it twice, and was lucky
to recover with fsck...
