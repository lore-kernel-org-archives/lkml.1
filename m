Return-Path: <linux-kernel-owner+w=401wt.eu-S1761000AbYA1M0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761000AbYA1M0b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 07:26:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760924AbYA1M0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 07:26:20 -0500
Received: from aun.it.uu.se ([130.238.12.36]:36390 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761038AbYA1M0R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 07:26:17 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18333.51681.780267.521513@harpo.it.uu.se>
Date: Mon, 28 Jan 2008 13:26:09 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mikael Pettersson <mikpe@it.uu.se>, Gene Heskett <gene.heskett@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Problem with ata layer in 2.6.24
In-Reply-To: <1201521783.6149.33.camel@lappy>
References: <200801272122.21823.gene.heskett@gmail.com>
	<18333.36746.819935.641383@harpo.it.uu.se>
	<1201521783.6149.33.camel@lappy>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra writes:
 > 
 > On Mon, 2008-01-28 at 09:17 +0100, Mikael Pettersson wrote:
 > 
 > > 1. Wrong mailing list; use linux-ide (@vger) instead.
 > 
 > What, and keep all us other interested people in the dark?

MAINTAINERS clearly lists linux-ide as the primary mailing
list for all things IDE/ATA.

The original report only went to LKML, thus it has a high
chance of being missed or ignored by those most capable of
dealing with it.

If a topic is of general interest a simple Cc: lkml will
keep other parties in the loop.
