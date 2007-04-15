Return-Path: <linux-kernel-owner+w=401wt.eu-S1752361AbXDOD2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752361AbXDOD2S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 23:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752387AbXDOD2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 23:28:18 -0400
Received: from www.osadl.org ([213.239.205.134]:46438 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752326AbXDOD2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 23:28:18 -0400
Subject: Re: [2.6 patch] the scheduled -EINVAL for invalid timevals in
	setitimer
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Adrian Bunk <bunk@stusta.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070414150302.GF3691@stusta.de>
References: <20070406102036.GF29169@stusta.de>
	 <1175855360.28263.439.camel@localhost.localdomain>
	 <20070414150302.GF3691@stusta.de>
Content-Type: text/plain
Date: Sun, 15 Apr 2007 05:29:22 +0200
Message-Id: <1176607762.3387.81.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-04-14 at 17:03 +0200, Adrian Bunk wrote:
> As scheduled, do_setitimer() now returns -EINVAL for invalid timeval.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>

Acked-by: Thomas Gleixner <tglx@linutronix.de>



