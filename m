Return-Path: <linux-kernel-owner+w=401wt.eu-S965988AbXCFSfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965988AbXCFSfW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 13:35:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965996AbXCFSfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 13:35:21 -0500
Received: from main.gmane.org ([80.91.229.2]:54484 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965988AbXCFSfT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 13:35:19 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Dirk Schoebel <dirk@liji-und-dirk.de>
Subject: Re: OOPS with 2.6.20 and 2.6.21-rc2 (mos7720)
Followup-To: gmane.linux.usb.devel
Date: Tue, 06 Mar 2007 19:31:56 +0100
Message-ID: <eskc2s$4gp$1@sea.gmane.org>
References: <esjg1h$l8d$1@sea.gmane.org> <200703061207.53484.oliver@neukum.org> <esjv78$g3h$1@sea.gmane.org> <200703061618.26402.oliver@neukum.org> <esk1g3$nik$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: port-87-234-91-111.dynamic.qsc.de
User-Agent: KNode/0.10.4
Cc: linux-usb-devel@lists.sourceforge.net
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

...btw...
another usb serial adapter (single port ftdi) works well, no OOPSes
so.. maybe the error is less to search within usb-serial itself but more the
interaction or the driver itself...

Dirk.


