Return-Path: <linux-kernel-owner+w=401wt.eu-S1753537AbYLZNqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537AbYLZNqe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 08:46:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752965AbYLZNqS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 08:46:18 -0500
Received: from mx2.redhat.com ([66.187.237.31]:36622 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752725AbYLZNqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 08:46:17 -0500
Date: Fri, 26 Dec 2008 11:45:55 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org,
       Patrick Boettcher <patrick.boettcher@desy.de>
Subject: Re: [GIT PATCHES for 2.6.28] V4L/DVB fixes, crash in
 af9005_usb_module_init()
Message-ID: <20081226114555.17d664ef@caramujo.chehab.org>
In-Reply-To: <20081226132426.GA26953@elte.hu>
References: <20081224121252.7560391e@caramujo.chehab.org>
	<20081225081907.GA4628@elte.hu>
	<20081225212459.4c7e31b4@caramujo.chehab.org>
	<20081226090220.GF755@elte.hu>
	<20081226111324.3fbb804b@caramujo.chehab.org>
	<20081226132426.GA26953@elte.hu>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Dec 2008 14:24:26 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> here's that commit again, standalone, with the crash in 
> af9005_usb_module_init() embedded. Unfortunately i dont have the .config 
> anymore and the crash log is half a year old. I have re-enabled the driver 
> in tip/master so if the crash still triggers i should see it within 1-2 
> days and i can do a fuller bugreport.

Ok. Let's wait for your next round of tests on it. Maybe this happened at the
time the dvb register interface has changed a while ago. If so, the bug should
already have been fixed by now.

-- 

Cheers,
Mauro
