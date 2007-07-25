Return-Path: <linux-kernel-owner+w=401wt.eu-S1763851AbXGYGpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763851AbXGYGpt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 02:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758761AbXGYGpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 02:45:42 -0400
Received: from pcls5.std.com ([192.74.137.145]:48470 "EHLO TheWorld.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751603AbXGYGpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 02:45:41 -0400
From: Alan Curry <pacman@TheWorld.com>
Message-Id: <200707250645.l6P6jYnk1373598@shell01.TheWorld.com>
Subject: Re: [PATCH] powerpc: Pegasos keyboard detection
To: benh@kernel.crashing.org (Benjamin Herrenschmidt)
Date: Wed, 25 Jul 2007 02:45:34 -0400 (EDT)
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
In-Reply-To: <1185344548.5439.308.camel@localhost.localdomain> from "Benjamin Herrenschmidt" at Jul 25, 2007 04:22:28 PM
X-Mailer: ELM [version 2.5 PL2]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt writes the following:
>
>Doesn't it have something in "compatible" instead ? that would be the
>way to go.
>

Assuming that would be represented as a file named "compatible" in the
directory /proc/device-tree/*/*/8042@i60 ... no, it doesn't have one of
those.

For the amusement of all, I offer the entire device-tree as presented in
/proc by my running 2.6.22.1 kernel. Available for a limited time from
http://world.std.com/~pacman/pegasosII_proc_device-tree.tar.gz

-- 
Alan Curry
pacman@world.std.com
