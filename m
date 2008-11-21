Return-Path: <linux-kernel-owner+w=401wt.eu-S1755073AbYKULyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073AbYKULyf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 06:54:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753256AbYKULyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 06:54:24 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56424 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753103AbYKULyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 06:54:23 -0500
Date: Fri, 21 Nov 2008 11:54:15 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Peter Rabbitson <rabbit+list@rabbit.us>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>,
       linux-raid <linux-raid@vger.kernel.org>, linux-kernel@vger.kernel.org,
       martmontools-support@lists.sourceforge.net,
       Bruce Allen <ballen@gravity.phys.uwm.edu>
Subject: Re: Ninth(?) Velociraptor replacement or md(RAID)/smartmontools(?)
 bug?
Message-ID: <20081121115415.6c872f11@lxorguk.ukuu.org.uk>
In-Reply-To: <49269BCF.8060300@rabbit.us>
References: <alpine.DEB.1.10.0811210600310.5577@p34.internal.lan>
	<49269BCF.8060300@rabbit.us>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Oct 27 11:33:41 Arzamas kernel: ata6.00: error: { IDNF ABRT }

Different error. IDNF -> ID not found
