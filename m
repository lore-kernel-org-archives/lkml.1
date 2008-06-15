Return-Path: <linux-kernel-owner+w=401wt.eu-S1760267AbYFOSiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760267AbYFOSiA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 14:38:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759229AbYFOShx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 14:37:53 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36907 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759046AbYFOShw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 14:37:52 -0400
Message-ID: <48556174.9090708@firstfloor.org>
Date: Sun, 15 Jun 2008 20:37:40 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: devzero@web.de
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       kernel-testers@vger.kernel.org
Subject: Re: suse slab testing module "crasher"
References: <317948575@web.de>
In-Reply-To: <317948575@web.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> so, if it`s useful, who is reponsible for pushing it upstream ?

Nobody is. That is why it isn't. Feel free to do the work.

It would need some cleanup before submission. e.g. the ooops/panic etc. options
are fairly useless and should be removed and there needs to be more documentation.

-Andi
