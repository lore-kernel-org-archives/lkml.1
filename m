Return-Path: <linux-kernel-owner+w=401wt.eu-S1763460AbYALCGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763460AbYALCGe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 21:06:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756984AbYALCGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 21:06:25 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:55567 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717AbYALCGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 21:06:24 -0500
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [TOMOYO #6 retry 08/21] Utility functions and policy manipulationinterface.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20080109005320.323184643@nttdata.co.jp>
	<20080109005421.598247963@nttdata.co.jp>
	<Xine.LNX.4.64.0801091524500.13216@us.intercode.com.au>
	<Xine.LNX.4.64.0801091528160.13216@us.intercode.com.au>
In-Reply-To: <Xine.LNX.4.64.0801091528160.13216@us.intercode.com.au>
Message-Id: <200801121106.DBD21371.SVJOOHQFFLOFMt@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Sat, 12 Jan 2008 11:06:17 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

James Morris wrote:
> > > TOMOYO Linux uses /sys/kernel/security/tomoyo interface for configuration.
> > 
> > Why aren't you using securityfs for this?  (It was designed for LSMs).
> 
> Doh, it is using securityfs, don't worry.
> 
I got a mm-commits mail titled
"+ sysfs-make-sysfs_deprecated-depend-on-sysfs.patch added to -mm tree" .

Is sysfs going to be deprecated?

If sysfs becomes not available at /sys/ , where securityfs is going to be mounted?

Regards.
