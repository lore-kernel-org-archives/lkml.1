Return-Path: <linux-kernel-owner+w=401wt.eu-S1756588AbZFGVL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588AbZFGVL3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 17:11:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756393AbZFGVLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 17:11:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59876 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756425AbZFGVLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 17:11:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Martin Bammer <mrb74@gmx.at>
Subject: Re: [Bug #13391] Kernel boot hangs at about every second start when kms is activated
Date: Sun, 7 Jun 2009 23:11:46 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc8-rjw; KDE/4.2.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Eric Anholt <eric@anholt.net>
References: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera> <D9VoutSOyXP.A.E-G.TZ7KKB@chimera> <1244390641.4219.3.camel@localhost>
In-Reply-To: <1244390641.4219.3.camel@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906072311.47265.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 07 June 2009, Martin Bammer wrote:
> Since i disabled most of the debug options this problem has gone. IMHO
> this issue has been caused by kdbg.

Thanks for the update, I've dropped the bug from the list.

Best,
Rafael
