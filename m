Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965319Ab0B0Kdl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 05:33:41 -0500
Received: from 70-90-202-97-Albuquerque.hfc.comcastbusiness.net ([70.90.202.97]:36334
	"EHLO deneb.dwf.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S965052Ab0B0Kdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 05:33:40 -0500
X-Greylist: delayed 1356 seconds by postgrey-1.27 at vger.kernel.org; Sat, 27 Feb 2010 05:33:40 EST
Message-Id: <201002271011.o1RAB3in007369@deneb.dwf.com>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3
To: linux-kernel@vger.kernel.org
Subject: How to see kernel pr_err error messages.
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Sat, 27 Feb 2010 03:11:03 -0700
From: reg@dwf.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Im looking at some kernel code, and there are 'pr_err' error messages in
it that would help me discover my problem.

However I dont see them printing anywhere.

What do I have to do to see these error messages?
A search with GOOGLE  and a grep of the code wasnt too useful, but
it seems possible that I need to set

    #define CONFIG_DEBUG

Is that true?  I see a lot of <something>_DEBUGs in the .config file
but no simple CONFIG_DEBUG that is commented out.

In any case, how do I get these things to print?
-- 
                                        Reg.Clemens
                                        reg@dwf.com

