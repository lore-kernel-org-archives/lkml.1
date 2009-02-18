Return-Path: <linux-kernel-owner+w=401wt.eu-S1758790AbZBRV44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758790AbZBRV44 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 16:56:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753106AbZBRV4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 16:56:46 -0500
Received: from smtp.netsonic.fi ([194.29.192.26]:46514 "EHLO smtp.netsonic.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289AbZBRV4q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 16:56:46 -0500
X-Greylist: delayed 1780 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Feb 2009 16:56:46 EST
X-Hashcash: 1:20:090218:linux-kernel@vger.kernel.org::yOGh5UuyIg9WHDUg:0000000000000000000000000000000001HYa
X-Hashcash: 1:20:090218:gerickson@nuovations.com::0Hij+dP+YaBlDESR:00000000000000000000000000000000000007e4+
From: Timo Juhani Lindfors <timo.lindfors@iki.fi>
To: linux-kernel@vger.kernel.org
Cc: Grant Erickson <gerickson@nuovations.com>
Subject: Re: [RFC] Add Alternative Log Buffer Support for printk Messages
Date: Wed, 18 Feb 2009 23:27:04 +0200
Message-ID: <844oyrqvvb.fsf@sauna.l.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

we have been looking for a way to preserve panic messages over reboot
on the openmoko neo freerunner phone so you might find useful ideas
from

http://docs.openmoko.org/trac/ticket/2135

I wrote a 55-line patch (before knowing about your patch) that does
what I need but I am not a kernel developer so it is not of very high
quality. I hope your more general patch will get to the mainline.

best regards,
Timo Lindfors
