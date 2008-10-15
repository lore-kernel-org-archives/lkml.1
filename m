Return-Path: <linux-kernel-owner+w=401wt.eu-S1753684AbYJOBOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684AbYJOBOU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 21:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751454AbYJOBOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 21:14:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58449 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388AbYJOBOM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 21:14:12 -0400
Date: Tue, 14 Oct 2008 23:13:59 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Jiri Kosina <jikos@jikos.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] Adds a driver for Bright ABNT2 Brazilian keyboard
Message-ID: <20081014231359.7eccdc6c@pedra.chehab.org>
In-Reply-To: <alpine.LNX.1.10.0810142228230.26779@jikos.suse.cz>
References: <20081014110913.22f28ea7@pedra.chehab.org>
	<alpine.LNX.1.10.0810142228230.26779@jikos.suse.cz>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 14 Oct 2008 22:30:40 +0200 (CEST)
Jiri Kosina <jkosina@suse.cz> wrote:

> On Tue, 14 Oct 2008, Mauro Carvalho Chehab wrote:
> 
> > This keyboard needs to reset the LEDS during probe.
> 
> Thanks. We also need to have additional entry added into 
> drivers/hid/hid-dummy.c, because of the COMPAT fun. I will fix this up and 
> apply the patch.

OK, thanks. I'll pay attention on hid-dummy.c next time.

-- 

Cheers,
Mauro
