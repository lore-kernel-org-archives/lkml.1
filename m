Return-Path: <linux-kernel-owner+w=401wt.eu-S1754011AbYI0VeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011AbYI0VeU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 17:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbYI0VeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 17:34:13 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54158 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753271AbYI0VeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 17:34:12 -0400
Date: Sat, 27 Sep 2008 22:33:53 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Brice Figureau <brice+lkml@daysofwonder.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Serial console not working after device detection.
Message-ID: <20080927223353.668d652e@lxorguk.ukuu.org.uk>
In-Reply-To: <48DE6B6E.4050306@daysofwonder.com>
References: <48DE6B6E.4050306@daysofwonder.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Known problem - compile out the PnP serial support

