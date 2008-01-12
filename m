Return-Path: <linux-kernel-owner+w=401wt.eu-S1762667AbYALHe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762667AbYALHe0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 02:34:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758011AbYALHeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 02:34:18 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:56327 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024AbYALHeR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 02:34:17 -0500
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [TOMOYO #6 retry 08/21] Utility functions and policymanipulationinterface.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20080109005421.598247963@nttdata.co.jp>
	<Xine.LNX.4.64.0801091524500.13216@us.intercode.com.au>
	<Xine.LNX.4.64.0801091528160.13216@us.intercode.com.au>
	<200801121106.DBD21371.SVJOOHQFFLOFMt@I-love.SAKURA.ne.jp>
	<20080112044536.GA31404@kroah.com>
In-Reply-To: <20080112044536.GA31404@kroah.com>
Message-Id: <200801121634.BCF21091.VMJOOQSHFtOFFL@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Sat, 12 Jan 2008 16:34:10 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Greg KH wrote:
> > If sysfs becomes not available at /sys/ , where securityfs is going to be mounted?
> 
> sysfs is not going away any time soon, don't worry :)

I see. Thanks.
