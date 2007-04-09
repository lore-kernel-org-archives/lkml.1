Return-Path: <linux-kernel-owner+w=401wt.eu-S1753499AbXDIVwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499AbXDIVwh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 17:52:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753493AbXDIVwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 17:52:15 -0400
Received: from ozlabs.org ([203.10.76.45]:42514 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753509AbXDIVv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 17:51:59 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17946.46413.588746.26184@cargo.ozlabs.ibm.com>
Date: Tue, 10 Apr 2007 07:51:09 +1000
From: Paul Mackerras <paulus@samba.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nicolas Boichat <nicolas@boichat.ch>, Dmitry Torokhov <dtor@insightbb.com>,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       rlove@rlove.org, linux-kernel@hansmi.ch,
       Jean Delvare <khali@linux-fr.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] Apple SMC driver - fix input device
In-Reply-To: <20070409130432.f4902155.akpm@linux-foundation.org>
References: <45F7C083.7090504@boichat.ch>
	<45FE1D44.8000805@boichat.ch>
	<200703221137.35906.dtor@insightbb.com>
	<461A455C.9040508@boichat.ch>
	<20070409130432.f4902155.akpm@linux-foundation.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton writes:

> I've been assuming that this patch will go via Jean, since it is in
> drivers/hwmon/applesmc.c.  But perhaps that is inappropriate, and it is
> more a Paul or Dmitry thing.  Or a me thing.
> 
> Who wants to take it??

Not me, and I expect not Ben, since it's an intel-only mac thingy...

Paul.
