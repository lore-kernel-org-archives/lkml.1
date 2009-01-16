Return-Path: <linux-kernel-owner+w=401wt.eu-S935175AbZAPOKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935175AbZAPOKZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 09:10:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932344AbZAPOKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 09:10:06 -0500
Received: from main.gmane.org ([80.91.229.2]:48353 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760039AbZAPOKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 09:10:03 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Johannes Schindelin <johannes.schindelin@gmx.de>
Subject: Re: [PATCH] Morse code panics for 2.6.29-rc1
Date: Fri, 16 Jan 2009 13:56:48 +0000 (UTC)
Message-ID: <loom.20090116T134943-315@post.gmane.org>
References: <20090111190503.GA20861@louise.pinerecords.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 141.5.11.5 (Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.0.5) Gecko/2008121623 Ubuntu/8.10 (intrepid) Firefox/3.0.5)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomas Szepe <szepe <at> pinerecords.com> writes:

> 
> Bumped into this silly thing (morse code panics) by accident after
> 6 years or so, and couldn't resist updating it for a recent kernel.
> So, here goes, enjoy.
> 
> Patch against 2.6.29-rc1.

Did you not mean to make compilation i8042_panic_blink() dependent on
!CONFIG_MORSE_PANICS instead of removing it?

Ciao,
Dscho




