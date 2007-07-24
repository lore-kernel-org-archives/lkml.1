Return-Path: <linux-kernel-owner+w=401wt.eu-S1764999AbXGXDrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764999AbXGXDrk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 23:47:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756546AbXGXDr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 23:47:29 -0400
Received: from gw.goop.org ([64.81.55.164]:49981 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756464AbXGXDr2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 23:47:28 -0400
Message-ID: <46A5761C.1040308@goop.org>
Date: Mon, 23 Jul 2007 20:46:36 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Tilman Schmidt <tilman@imap.cc>
CC: LKML <linux-kernel@vger.kernel.org>, andi@firstfloor.org,
       nix.or.die@googlemail.com, Roland McGrath <roland@redhat.com>
Subject: Re: 2.6.22-git17 boot failure
References: <46A3EC92.3050504@imap.cc> <46A3FBB7.9000608@imap.cc> <46A46BF9.6010906@goop.org> <46A481FD.2030607@imap.cc> <46A4C081.6070305@goop.org> <46A504A3.3070205@imap.cc> <46A51079.5030006@goop.org> <46A53396.2060902@imap.cc>
In-Reply-To: <46A53396.2060902@imap.cc>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tilman Schmidt wrote:
> So yes, all of ahci, pata_marvell, aic7xxx, jbd, dm_mod, ext3 are in
> fact modules in initrd. Would it help to try a kernel with some or all
> of these built in?
>   

Yes, that would be useful.  It would help tell whether its a module
loading problem or a basic pci probing problem.

    J
