Return-Path: <linux-kernel-owner+w=401wt.eu-S1758761AbYJIMA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758761AbYJIMA4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 08:00:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756543AbYJIMAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 08:00:49 -0400
Received: from styx.suse.cz ([82.119.242.94]:37066 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756585AbYJIMAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 08:00:48 -0400
Subject: Re: 2.6.27-rc8 regression on arm: kernel will no longer boot on
 Sharp Zaurus c-3000
From: Stanislav Brabec <utx@penguin.cz>
To: Pavel Machek <pavel@suse.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, rpurdie@rpsys.net,
       lenz@cs.wisc.edu, Russell King <rmk@arm.linux.org.uk>,
       Dirk@Opfer-Online.de, arminlitzel@web.de, pavel.urban@ct.cz,
       metan@atrey.karlin.mff.cuni.cz, thommycheck@gmail.com, milan@ucw.cz
In-Reply-To: <20081009091929.GE29957@atrey.karlin.mff.cuni.cz>
References: <20081009091929.GE29957@atrey.karlin.mff.cuni.cz>
Content-Type: text/plain; charset="ISO-8859-2"
Date: Thu, 09 Oct 2008 14:00:46 +0200
Message-Id: <1223553647.3194.8.camel@hammer.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.0 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> ...unfortunately, its kind of hard to debug, as I'm testing kernels
> using kexec and only see messages late in boot. 2.6.26 works ok.

Lost patch:
http://lists.arm.linux.org.uk/lurker/message/20081007.113509.c17e1e65.en.html

OT: 2.6.26 does not work OK. You need I2C init patch.

-- 
Best Regards / S pozdravem,

Stanislav Brabec
software developer
---------------------------------------------------------------------
SUSE LINUX, s. r. o.                          e-mail: sbrabec@suse.cz
Lihovarská 1060/12           tel: +420 284 028 966, +49 911 740538747
190 00 Praha 9                                  fax: +420 284 028 951
Czech Republic                                    http://www.suse.cz/

