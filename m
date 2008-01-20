Return-Path: <linux-kernel-owner+w=401wt.eu-S1756058AbYATTZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058AbYATTZ3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 14:25:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754961AbYATTZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 14:25:17 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:59511 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755257AbYATTZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 14:25:16 -0500
Date: Sun, 20 Jan 2008 21:23:57 +0200
From: Adrian Bunk <bunk@kernel.org>
To: gerg@uclinux.org, Miles Bader <miles@gnu.org>
Cc: linux-kernel@vger.kernel.org
Subject: RFC: Removal of the v850 port?
Message-ID: <20080120192356.GI8669@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is anyone maintaining the v850 port in the Linux kernel or will work on 
getting it back into a usable state in the foreseeable future?

Otherwise I'll send a patch to remove it.

That's not meant personally against anyone, and it would not prevent the 
port from getting back into the kernel in the future if someone will 
start getting it back into a usable state, but in it's current state 
it is simply useless.

cu
Adrian


----- Forwarded message from Adrian Bunk <bunk@kernel.org> -----

Date:  Tue, 1 Jan 2008 15:50:21 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Miles Bader <miles@gnu.org>
Cc: linux-kernel@vger.kernel.org
Subject: Status of the v850 port?

Trying to compile the v850 port brings you many compile errors, one of 
them exists since at least kernel 2.6.19.

Are there any patches in some external tree that should be merged?

Or will anyone work on getting this port back into a usable state in the 
forseeable future?

Otherwise the only reasonable option would be to remove this port from 
the kernel sources since it is dead code.

cu
Adrian

----- End forwarded message -----

