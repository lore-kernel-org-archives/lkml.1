Return-Path: <linux-kernel-owner+w=401wt.eu-S1765612AbZAQTkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765612AbZAQTkr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 14:40:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763908AbZAQTkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 14:40:37 -0500
Received: from s15216962.onlinehome-server.info ([217.160.22.205]:39167 "EHLO
	s15216962.onlinehome-server.info" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763785AbZAQTkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 14:40:37 -0500
Date: Sat, 17 Jan 2009 20:38:41 +0100
From: Enrico Weigelt <weigelt@metux.de>
To: linux-kernel@vger.kernel.org
Subject: Re: linux kernel without file system
Message-ID: <20090117193841.GB5003@nibiru.local>
Reply-To: weigelt@metux.de
References: <496DA678.1090701@wpkg.org> <20090114093422.GA9771@frolo.macqel> <1231926744.11907.12.camel@skunk> <ac3eb2510901140234m29ca516bocd0e7dd997122a7b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac3eb2510901140234m29ca516bocd0e7dd997122a7b@mail.gmail.com>
User-Agent: Mutt/1.4.1i
X-Terror: bin laden, kill bush, Briefbombe, Massenvernichtung, KZ, 
X-Nazi: Weisse Rasse, Hitlers Wiederauferstehung, 42, 
X-Antichrist: weg mit schaeuble, ausrotten, heiliger krieg, al quaida, 
X-Killer: 23, endloesung, Weltuntergang, 
X-Doof: wer das liest ist doof
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kay Sievers <kay.sievers@vrfy.org> wrote:

> There are no device nodes in sysfs to talk to the device, only
> attributes, which are mostly plain small text files.

Actually, it would be really cool if all serial port operations
could be done via sysfs, so we don't need the device node 
(including all its ioctl()) at all.


BTW: did I already mention that I don't like ioctl() ?

cu
-- 
---------------------------------------------------------------------
 Enrico Weigelt    ==   metux IT service - http://www.metux.de/
---------------------------------------------------------------------
 Please visit the OpenSource QM Taskforce:
 	http://wiki.metux.de/public/OpenSource_QM_Taskforce
 Patches / Fixes for a lot dozens of packages in dozens of versions:
	http://patches.metux.de/
---------------------------------------------------------------------
