Return-Path: <linux-kernel-owner+w=401wt.eu-S932501AbYDOUll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932501AbYDOUll (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 16:41:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756671AbYDOUl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 16:41:27 -0400
Received: from dell.benran.ru ([83.149.196.126]:49707 "EHLO ari.home"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932308AbYDOUl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 16:41:26 -0400
Date: Wed, 16 Apr 2008 00:41:19 +0400 (MSD)
From: "Lev A. Melnikovsky" <melnikovsky@mail.ru>
To: Oliver Neukum <oliver@neukum.org>
cc: Rene Herman <rene.herman@keyaccess.nl>,
       Alessandro Suardi <alessandro.suardi@gmail.com>,
       David Brownell <david-b@pacbell.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: ehci-hcd affects hda speed
In-Reply-To: <200804152202.18358.oliver@neukum.org>
Message-ID: <alpine.LFD.1.10.0804160039420.4157@nev.ubzr>
References: <alpine.LFD.1.00.0803050036210.31935@nev.ubzr> <47E1B062.4060709@keyaccess.nl> <alpine.LFD.1.10.0804152220560.6429@nev.ubzr> <200804152202.18358.oliver@neukum.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  On Wed, 16 Apr 2008 at 12:02am, Oliver Neukum wrote:

ON> Am Dienstag, 15. April 2008 21:56:24 schrieb Lev A. Melnikovsky:
ON> > The oddest peculiarity for me is the hysteretic difference between #1 and 
ON> > #3 states. I mean experimental data (hda throughput) depends not on the 
ON> > state (hardware/loaded modules), but on the path we followed.
ON> 
ON> Did you compile with CONFIG_USB_SUSPEND?

# CONFIG_USB_SUSPEND is not set

Does this explain something?

Thanks
-L
