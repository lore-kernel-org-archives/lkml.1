Return-Path: <linux-kernel-owner+w=401wt.eu-S1754618AbYCIUUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618AbYCIUUJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 16:20:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752900AbYCIUT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 16:19:58 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:34131 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751313AbYCIUT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 16:19:57 -0400
Date: Sun, 9 Mar 2008 20:06:55 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Dave Young" <hidave.darkstar@gmail.com>,
       "Johannes Weiner" <hannes@saeurebad.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] add time_now_after and other macros which compare
 with jiffies
Message-ID: <20080309200655.256c8c32@core>
In-Reply-To: <20080309120133.2d1363e4.akpm@linux-foundation.org>
References: <200803080735.06984.hidave.darkstar@gmail.com>
	<877igd6vqn.fsf@saeurebad.de>
	<a8e1da0803081654l50fdda44jbbed1d1ed2caf9ae@mail.gmail.com>
	<20080309095802.70d91c7b@core>
	<a8e1da0803090344l7f468326r8d3844e20ede08a3@mail.gmail.com>
	<20080309110808.2249aa3a@core>
	<20080309120133.2d1363e4.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We could call them time_is_after_jiffies(), time_is_before_jiffies(), etc.
> 
> Those names are actually better than time_after_now(), etc.

Agreed - and if you think its worth doing I bow to your expertise on
buggy patch submissions..
