Return-Path: <linux-kernel-owner+w=401wt.eu-S1751782AbYKWWqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782AbYKWWqv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 17:46:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752006AbYKWWqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 17:46:31 -0500
Received: from s15216962.onlinehome-server.info ([217.160.22.205]:56101 "EHLO
	s15216962.onlinehome-server.info" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751871AbYKWWqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 17:46:30 -0500
X-Greylist: delayed 353 seconds by postgrey-1.27 at vger.kernel.org; Sun, 23 Nov 2008 17:46:30 EST
Date: Sun, 23 Nov 2008 23:37:54 +0100
From: Enrico Weigelt <weigelt@metux.de>
To: linux-kernel@vger.kernel.org
Subject: Re: scanner interface proposal was: [TALPA] Intro to a linux interface for on access scanning (fwd)
Message-ID: <20081123223753.GA16424@nibiru.local>
Reply-To: weigelt@metux.de
References: <alpine.DEB.1.10.0808171824060.12859@asgard.lang.hm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0808171824060.12859@asgard.lang.hm>
User-Agent: Mutt/1.4.1i
X-Terror: bin laden, kill bush, Briefbombe, Massenvernichtung, KZ,
X-Nazi: Weisse Rasse, Hitlers Wiederauferstehung, 42,
X-Antichrist: weg mit schaeuble, ausrotten, heiliger krieg, al quaida,
X-Killer: 23, endloesung, Weltuntergang,
X-Doof: wer das liest ist doof
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* david@lang.hm <david@lang.hm> wrote:

<big_snip />

Hi folks,

I've just battled through the tons of text in this thread and 
really wonder why this is a kernel issue at all.

You want to keep track if certain files are changed ? 
Any you want to block/delay access to unchecked or 
considered-malicous files ? 

Fine. Why not just putting this into a userland filesystem ?
Coding an 9P server is quite trivial. So why messing up the 
kernel with stuff clearly belonging into userland ?  ;-o


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
