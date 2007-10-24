Return-Path: <linux-kernel-owner+w=401wt.eu-S1755480AbXJXFZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480AbXJXFZj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 01:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756185AbXJXFZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 01:25:21 -0400
Received: from bromine.webpack.hosteurope.de ([217.115.142.123]:59892 "EHLO
	bromine.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756109AbXJXFZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 01:25:18 -0400
X-Greylist: delayed 1917 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Oct 2007 01:25:18 EDT
Date: Wed, 24 Oct 2007 06:53:12 +0200
From: speedy <speedy@3d-io.com>
X-Mailer: The Bat! (v3.80.06) Professional
Reply-To: speedy <speedy@3d-io.com>
X-Priority: 3 (Normal)
Message-ID: <982792802.20071024065312@3d-io.com>
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add eeprom_bad_csum_allow module option to e1000.
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;speedy@3d-io.com;1193203518;a1a5594f;
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Auke, Kernel crew,

> I realize that you need the patch to actually create it but the
> danger is that people will start using it *without* troubleshooting the real
> issue.  

Just write out a big fat kernel output with explanations of
the override parameter, possible repercusionss of not fixing it
and an email address to which you (or, better yet - Intel) want
stuff "this and that" reported.

I hadn't the slightest idea from the kernel messages or the skim of
the driver source that anyone is wanting feedback on this issue...

ps. Were there recently (2.6.22+) any known issues about e1000 refusing
to send packets out / getting stuck upon jumbo-frames being enabled?

ps2. I'm not following this list, sorry about the poor thread CC:
quality


-- 
Best regards,
 speedy                          mailto:speedy@3d-io.com

