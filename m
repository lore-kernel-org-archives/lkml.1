Return-Path: <linux-kernel-owner+w=401wt.eu-S1423694AbXD3VgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423694AbXD3VgW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 17:36:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423696AbXD3VgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 17:36:22 -0400
Received: from www.osadl.org ([213.239.205.134]:60775 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1423694AbXD3VgV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 17:36:21 -0400
Subject: Re: Linux 2.6.21: pmtmr losing time
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Joerg Sommrey <jo@sommrey.de>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>
In-Reply-To: <20070430163944.GA29206@sommrey.de>
References: <20070430125200.GA5379@sommrey.de>
	 <1177950216.5791.241.camel@localhost.localdomain>
	 <20070430163944.GA29206@sommrey.de>
Content-Type: text/plain
Date: Mon, 30 Apr 2007 23:38:34 +0200
Message-Id: <1177969115.5791.244.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-30 at 18:39 +0200, Joerg Sommrey wrote:
> Here it is.  Maybe this problem is related to the usage of the
> "experimental" amd76x_pm module?

Can you please verify what happens w/o that module ?

Thanks,

	tglx


