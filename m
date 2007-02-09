Return-Path: <linux-kernel-owner+w=401wt.eu-S1946625AbXBIQgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946625AbXBIQgy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 11:36:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946626AbXBIQgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 11:36:54 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59415 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946625AbXBIQgx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 11:36:53 -0500
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dtor_core@ameritech.net>
Subject: Re: WHATIS scan_keyb
References: <45CC8F2D.3070902@gmail.com>
From: Andi Kleen <ak@suse.de>
Date: 09 Feb 2007 18:37:13 +0100
In-Reply-To: <45CC8F2D.3070902@gmail.com>
Message-ID: <p73lkj71bcm.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby <jirislaby@gmail.com> writes:

> Hi.
> 
> What's drivers/char/scan_keyb.{c,h} for, when it's referenced in no
> place (aside a fact, that it uses some old API and hence is broken)?

iirc it was an interface for braille reader modules. Probably they
never made it into tree.

-Andi

