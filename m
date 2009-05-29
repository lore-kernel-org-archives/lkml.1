Return-Path: <linux-kernel-owner+w=401wt.eu-S1756197AbZE2Vwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197AbZE2Vwm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 17:52:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752442AbZE2Vwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 17:52:34 -0400
Received: from ns.penguin.cz ([84.21.108.25]:40812 "EHLO ns.penguin.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751907AbZE2Vwd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 17:52:33 -0400
X-Greylist: delayed 1324 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 May 2009 17:52:33 EDT
Subject: Re: unbreak suspend on zaurus on 2.6.30-rc6
From: Stanislav Brabec <utx@penguin.cz>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       Cyril Hrubis <metan@ucw.cz>
In-Reply-To: <20090529105619.GA24187@elf.ucw.cz>
References: <20090529105619.GA24187@elf.ucw.cz>
Content-Type: text/plain
Date: Fri, 29 May 2009 23:30:29 +0200
Message-Id: <1243632629.9207.5.camel@utx.utx.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:

> This is hacky patch to unbreak suspend on -rc6; perhaps it will be
> useful to someone.

Thanks for the patch. I tried rc7 yesterday with same problem.

Your patch makes resume working again. Serial console does not work
after resume, inserting or removing charger causes resume, and syslog is
a bit noisy now.


________________________________________________________________________
Stanislav Brabec
http://www.penguin.cz/~utx/zaurus

