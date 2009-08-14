Return-Path: <linux-kernel-owner+w=401wt.eu-S1752841AbZHNJa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841AbZHNJa0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 05:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751989AbZHNJa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 05:30:26 -0400
Received: from lvps87-230-0-242.dedicated.hosteurope.de ([87.230.0.242]:58368
	"EHLO lvps87-230-0-242.dedicated.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751958AbZHNJaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 05:30:25 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Aug 2009 05:30:25 EDT
MIME-Version: 1.0
Date: Fri, 14 Aug 2009 11:23:42 +0200
From: Michael Guntsche <mike@it-loops.com>
To: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RT] pty low latency
Message-ID: <a00c09d60d1685e79a5bde787c2dfd93@localhost>
User-Agent: RoundCube Webmail/0.2-beta
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Forgot CC'ing linux-kernel

-------- Original Message --------
Subject: Re: [PATCH][RT] pty low latency
Date: Fri, 14 Aug 2009 07:19:14 +0200
From: Michael Guntsche <mike@it-loops.com>
To: <sdietrich@novell.com>

Good morning,

I think this patch will break applications like pptp again. Please take a
look at

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=e043e42bdb66885b3ac10d27a01ccb9972e2b0a3

I am not sure if there is a differnce with the RT patches. But I can assure
you that I get a kernel panic after 2 minutes of uptime with this patch
reverted in the vanilla kernel.

Kind regards,
Michael
