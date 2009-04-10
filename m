Return-Path: <linux-kernel-owner+w=401wt.eu-S1762013AbZDJFaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762013AbZDJFaX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 01:30:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759499AbZDJF37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 01:29:59 -0400
Received: from mfbichi12.ns.itscom.net ([219.110.2.190]:60364 "EHLO
	mfbichi12.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756627AbZDJF36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 01:29:58 -0400
X-Greylist: delayed 787 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Apr 2009 01:29:58 EDT
From: hooanon05@yahoo.co.jp
Subject: Re: current->mm == NULL in security_vm_enough_memory(). 
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: jmorris@namei.org, alan@redhat.com, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
In-Reply-To: <200904092105.HBG52601.MHFOtQOLSVFOFJ@I-love.SAKURA.ne.jp>
References: <200903260130.n2Q1U9EJ040448@www262.sakura.ne.jp> <alpine.LRH.2.00.0903261236580.30336@tundra.namei.org> <200904092105.HBG52601.MHFOtQOLSVFOFJ@I-love.SAKURA.ne.jp>
Date: Fri, 10 Apr 2009 14:14:59 +0900
Message-ID: <28936.1239340499@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Tetsuo Handa:
> I don't see this message for 2.6.29 and earlier.
> As of 2.6.30-rc1, this problem is not solved yet.
> I think something happened between 2.6.29 and 2.6.30-rc1.

I could not reproduce the problem.
Are there any conditions?


J. R. Okajima
