Return-Path: <linux-kernel-owner+w=401wt.eu-S1753701AbZFIWrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701AbZFIWrc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 18:47:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753060AbZFIWrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 18:47:25 -0400
Received: from cantor.suse.de ([195.135.220.2]:49488 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752496AbZFIWrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 18:47:24 -0400
Date: Wed, 10 Jun 2009 00:47:26 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Pavel Machek <pavel@ucw.cz>
Cc: dda@awalis.com, kernel list <linux-kernel@vger.kernel.org>
Subject: Re: keyboard problems on HP Pavilion ZE4200
In-Reply-To: <20090609200202.GC1388@ucw.cz>
Message-ID: <alpine.LNX.2.00.0906100046410.7457@wotan.suse.de>
References: <3277220fa08b0d9b83dd7598e6f360d5@192.168.1.20> <20090609200202.GC1388@ucw.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Jun 2009, Pavel Machek wrote:

> > Under linux (ubuntu 9) some keys are "pressed" even when I'm not 
> > touching the keyboard, so for example it launches the tool for the 
> > printscreen hundreds of times and then the machine is not usable 
> > anymore...
> Which kernel? Does it happen on 2.6.30? Does it happen on console?
> Which keys?

Also output of 'evtest' on the corresponding device in /dev/input/event? 
from the time the key(s) get stuck will be helpful.

Is the keyboard in question PS2-conntected or USB-connected?

-- 
Jiri Kosina
SUSE Labs
