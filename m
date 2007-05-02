Return-Path: <linux-kernel-owner+w=401wt.eu-S1766760AbXEBQwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766760AbXEBQwq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 12:52:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766767AbXEBQwq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 12:52:46 -0400
Received: from www.osadl.org ([213.239.205.134]:50421 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1766760AbXEBQwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 12:52:45 -0400
Subject: Re: [PATCH] clockchips.h: kernel-doc fix
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200705021948.47563.sshtylyov@ru.mvista.com>
References: <200705021948.47563.sshtylyov@ru.mvista.com>
Content-Type: text/plain
Date: Wed, 02 May 2007 18:55:02 +0200
Message-Id: <1178124903.25504.22.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-02 at 19:48 +0400, Sergei Shtylyov wrote:
> Fix misnamed fields of 'struct clock_event_device' in the kernel-doc comment.
> Convert the acronyms to uppercase, while at it...
> 
> Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

Acked-by: Thomas Gleixner <tglx@linutronix.de>


