Return-Path: <linux-kernel-owner+w=401wt.eu-S1762231AbXGNLez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762231AbXGNLez (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 07:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756895AbXGNLes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 07:34:48 -0400
Received: from fmmailgate03.web.de ([217.72.192.234]:43833 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756455AbXGNLes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 07:34:48 -0400
From: Markus <lists4me@web.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] CFS scheduler, -v19
Date: Sat, 14 Jul 2007 13:34:45 +0200
User-Agent: KMail/1.9.5
References: <20070706173319.GA2356@elte.hu>
In-Reply-To: <20070706173319.GA2356@elte.hu>
Cc: Ingo Molnar <mingo@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707141334.45628.lists4me@web.de>
X-Provags-ID: V01U2FsdGVkX19ztVKChG09xdPk1BZw2UPnqgGpqRtj5a1jhcR/
	pvWUgJ9bep7BE5WZkG/DBf1EMgKZOjitdYHzFkg4QaEvZlNQA3
	/tAaL2Gfw=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> i'm pleased to announce release -v19 of the CFS scheduler patchset.
> 
> The rolled-up CFS patch against today's -git kernel, v2.6.22-rc7, 
> v2.6.22-rc6-mm1, v2.6.21.5 or v2.6.20.14 can be downloaded from the 
> usual place:
> 
>     http://people.redhat.com/mingo/cfs-scheduler/
Well, I took a 2.6.21 (gentoo-patchset...) and applied your cfs-v19 
patch for the 2.6.21 kernels. Its a amd64 system and the "normal" 
(=only gentoo patches) kernel is working fine!

> As usual, any sort of feedback, bugreport, fix and suggestion is more 
> than welcome!

When I start the system, the mouse is jerking like under heavy load. 
(also its idle!)
Then some programs just quit. They just disappear, no message in any 
log. (It were about four apps I realized in a period of about two hours 
of testing.)

I'll try a git snapshot next, but is there a way I can get more output?

Greetz
Markus
