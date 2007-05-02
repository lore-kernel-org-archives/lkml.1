Return-Path: <linux-kernel-owner+w=401wt.eu-S1767269AbXEBTIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767269AbXEBTIl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 15:08:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767259AbXEBTIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 15:08:41 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:37236 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767269AbXEBTIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 15:08:40 -0400
Date: Wed, 2 May 2007 21:05:28 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
cc: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: checkpatch, a patch checking script.
In-Reply-To: <Pine.LNX.4.62.0705021626080.3706@pademelon.sonytel.be>
Message-ID: <Pine.LNX.4.61.0705022103230.18504@yvahk01.tjqt.qr>
References: <20070423141123.GA21174@skybase> <20070423104534.51bac974.akpm@linux-foundation.org>
 <20070425112133.4ae86399.randy.dunlap@oracle.com>
 <20070425143011.57247c1d.akpm@linux-foundation.org>
 <20070425172447.1576c399.akpm@linux-foundation.org> <20070426003911.GA19383@redhat.com>
 <4630109F.6090002@oracle.com> <20070425200207.77a2721a.akpm@linux-foundation.org>
 <20070428030805.GA13331@redhat.com> <Pine.LNX.4.62.0705021626080.3706@pademelon.sonytel.be>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 2 2007 16:28, Geert Uytterhoeven wrote:

>  - Check for all of (u)int{8,16,32,64}_t

I strongly disagree. These should be allowed, for they are (I think) C99.


Jan
-- 
