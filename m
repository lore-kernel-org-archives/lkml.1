Return-Path: <linux-kernel-owner+w=401wt.eu-S1761690AbXKQSC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761690AbXKQSC2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 13:02:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754293AbXKQSCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 13:02:22 -0500
Received: from py-out-1112.google.com ([64.233.166.176]:1483 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938AbXKQSCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 13:02:21 -0500
Message-ID: <1618816c0711171002j7791e0b7g694498ef7448b2e0@mail.gmail.com>
Date: Sat, 17 Nov 2007 11:02:20 -0700
From: "Raymano Garibaldi" <raymano@faunos.com>
To: linux-kernel@vger.kernel.org
Subject: [REQUEST] New boot flag/kernel option
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I would like to request a new boot flag/kernel option that would make
the following scenario possible:

1) Working on laptop with a live USB distro on a read-only USB stick.
2) Suspend laptop.
3) Detach USB stick.

4) Do other things, get on a plane, go on a bus, deal with police
officer giving you a ticket for operating a laptop while driving...

5) Attach the same read-only USB stick.
6) Resume laptop.
7) Continue work as if nothing happened.

The last time we were able to do something like this was in 2.6.21.

If not, could you please advise a workaround to get this functionality
with the latest kernels.

Thank you very much,
Raymano
