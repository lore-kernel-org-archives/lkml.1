Return-Path: <linux-kernel-owner+w=401wt.eu-S1750913AbXCUJGJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750913AbXCUJGJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 05:06:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751042AbXCUJGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 05:06:08 -0400
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:49789 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750913AbXCUJGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 05:06:07 -0400
Date: Wed, 21 Mar 2007 11:06:05 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: Adrian Bunk <bunk@stusta.de>
cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: 2.6.21-rc4: pl2303 disconnect oops
In-Reply-To: <20070319072749.GD752@stusta.de>
Message-ID: <Pine.SOC.4.64.0703211105330.3385@math>
References: <Pine.SOC.4.64.0703190835280.28512@math> <20070319072749.GD752@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> This looks like one of the known regressions.
> 
> Does the patch in [1] help?
> 
> [1] http://lkml.org/lkml/2007/3/13/217

Yes, it also seems to be in mainline now, and with yesterdays git it 
works fine.

-- 
Meelis Roos (mroos@linux.ee)
