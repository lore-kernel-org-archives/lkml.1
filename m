Return-Path: <linux-kernel-owner+w=401wt.eu-S932423AbXFEJfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932423AbXFEJfh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 05:35:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763699AbXFEJfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 05:35:10 -0400
Received: from mx1.suse.de ([195.135.220.2]:39066 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763607AbXFEJfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 05:35:09 -0400
Date: Tue, 5 Jun 2007 11:34:29 +0200
From: Stefan Seyfried <seife@suse.de>
To: Xavier Bestel <xavier.bestel@free.fr>
Cc: nigel@nigel.suspend2.net, Jeremy Maitin-Shepard <jmaitins@andrew.cmu.edu>,
       Pavel Machek <pavel@ucw.cz>, Jeremy Maitin-Shepard <jbms@cmu.edu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>
Subject: Re: A kexec approach to hibernation
Message-ID: <20070605093429.GB5229@suse.de>
References: <878xb3l888.fsf@jbms.ath.cx> <200706020114.37245.rjw@sisk.pl> <87odjz9qo9.fsf@jbms.ath.cx> <200706020233.44509.rjw@sisk.pl> <87k5un9l4n.fsf@jbms.ath.cx> <20070604104621.GB4405@elf.ucw.cz> <20070604220910.GB2515@andrew.cmu.edu> <1180996586.4356.65.camel@nigel.suspend2.net> <1181031341.6863.164.camel@frg-rhel40-em64t-04>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1181031341.6863.164.camel@frg-rhel40-em64t-04>
X-Operating-System: openSUSE 10.3 (i586) Alpha4plus, Kernel 2.6.22-rc2-git7-2-default
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2007 at 10:15:41AM +0200, Xavier Bestel wrote:
> FWIW, on my old laptop apm beats any kernel solution hands down in terms
> of speed

This might be true on 64MB systems. It is surely not true on multi-Gigabyte-
RAM setups. At least not if you actually use that memory for anything
including filesystem cache.
And you simply cannot buy a new machine today that still supports APM suspend
to disk.
-- 
Stefan Seyfried
QA / R&D Team Mobile Devices        |              "Any ideas, John?"
SUSE LINUX Products GmbH, Nürnberg  | "Well, surrounding them's out." 

This footer brought to you by insane German lawmakers:
SUSE Linux Products GmbH, GF: Markus Rex, HRB 16746 (AG Nürnberg)
