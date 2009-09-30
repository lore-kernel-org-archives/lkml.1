Return-Path: <linux-kernel-owner+w=401wt.eu-S1755054AbZI3T1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054AbZI3T1X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 15:27:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754825AbZI3T1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 15:27:22 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:57284 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752204AbZI3T1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 15:27:22 -0400
Date: Wed, 30 Sep 2009 15:22:32 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Thomas Gleixner <tglx@linutronix.de>
cc: linux-kernel@vger.kernel.org
Subject: 2.6.32-rc2: hrtimer: interrupt too slow, forcing clock min delta to
 2391 ns
Message-ID: <alpine.DEB.1.10.0909301520540.15983@gentwo.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Strange message. This is a state of the art Dell R610 running AIM7 with
lots of debugging on. Whats going on?

kmemleak: 557 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
hrtimer: interrupt too slow, forcing clock min delta to 2391 ns



