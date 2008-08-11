Return-Path: <linux-kernel-owner+w=401wt.eu-S1756134AbYHKQ44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134AbYHKQ44 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 12:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751513AbYHKQ4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 12:56:47 -0400
Received: from hiauly1.hia.nrc.ca ([132.246.100.193]:2920 "EHLO
	hiauly1.hia.nrc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416AbYHKQ4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 12:56:46 -0400
Subject: Re: [2.6 patch] binfmt_som.c: add MODULE_LICENSE
To: bunk@kernel.org (Adrian Bunk)
Date: Mon, 11 Aug 2008 12:56:43 -0400 (EDT)
From: "John David Anglin" <dave@hiauly1.hia.nrc.ca>
Cc: grundler@parisc-linux.org, kyle@mcmartin.ca, matthew@wil.cx,
       linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, bdale@hp.com
In-Reply-To: <20080811155158.GA21292@cs181140183.pp.htv.fi> from "Adrian Bunk" at Aug 11, 2008 06:51:58 pm
X-Mailer: ELM [version 2.4 PL25]
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Message-Id: <20080811165644.B18F04DE6@hiauly1.hia.nrc.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The toplevel COPYING file of the kernel sources contains the exact 
> licence text for all files (including binfmt_som.c) in the kernel.

The COPYING file contains the license text but it doesn't say clearly
what the license applies to.  The closest thing to this is the statement

   Also note that the GPL below is copyrighted by the Free Software
   Foundation, but the instance of code that it refers to (the Linux
   kernel) is copyrighted by me and others who actually wrote it.

in the COPYING file.  The applicability of the GPL is parenthetical.
The HOWTO file is more specific, but a clear license statement at the
top level of the "source" tree is missing.

Dave
-- 
J. David Anglin                                  dave.anglin@nrc-cnrc.gc.ca
National Research Council of Canada              (613) 990-0752 (FAX: 952-6602)
