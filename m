Return-Path: <linux-kernel-owner+w=401wt.eu-S1760747AbXJLSMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760747AbXJLSMj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 14:12:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757420AbXJLSMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 14:12:30 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:57292 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757322AbXJLSMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 14:12:30 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <470FB8F3.5050509@s5r6.in-berlin.de>
Date: Fri, 12 Oct 2007 20:12:03 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
CC: krh@redhat.com, linux1394-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 2/2] ieee1394_core.c: use DEFINE_SPINLOCK for spinlock
 definition
References: <20071012175723.GE3564@traven>
In-Reply-To: <20071012175723.GE3564@traven>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matthias Kaehlcke wrote:
> drivers/ieee1394/ieee1394_core.c: Define spinlock using
> DEFINE_SPINLOCK instead of assignment to SPIN_LOCK_UNLOCKED

Committed to linux1394-2.6.git, thanks.
-- 
Stefan Richter
-=====-=-=== =-=- -==--
http://arcgraph.de/sr/
