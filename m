Return-Path: <linux-kernel-owner+w=401wt.eu-S1752480AbZHSPUB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480AbZHSPUB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 11:20:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752146AbZHSPUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 11:20:00 -0400
Received: from fbr02.csee.onr.siteprotect.com ([64.26.60.146]:34558 "EHLO
	fbr02.csee.onr.siteprotect.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752138AbZHSPT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 11:19:59 -0400
X-Greylist: delayed 1506 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Aug 2009 11:19:59 EDT
Date: Wed, 19 Aug 2009 10:53:47 -0400 (EDT)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: John Stoffel <john@stoffel.org>
Cc: devzero@web.de, Martin Rogge <marogge@onlinehome.de>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.30.1-4 kernels freezes dual pentium-3 system
In-Reply-To: <19082.48492.202649.61984@stoffel.org>
Message-ID: <Pine.LNX.4.64.0908191052001.13866@pianoman.cluster.toy>
References: <859079895@web.de> <19072.12751.294751.725334@stoffel.org>
 <19082.48492.202649.61984@stoffel.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I just wanted to add, I am seeing similar freezes on an ancient dual 
Pentium Pro system I have.  I've been having issues tracking down the 
problem as well; often it locks up before I can complete building a 
kernel.

Do you have perf enabled?  I hope the lockup isn't somehow due to the
enable p6 perf counters patches.

Vince
