Return-Path: <linux-kernel-owner+w=401wt.eu-S1761019AbYALDHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761019AbYALDHR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 22:07:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756975AbYALDHD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 22:07:03 -0500
Received: from namei.org ([69.55.235.186]:36639 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753822AbYALDHB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 22:07:01 -0500
Date: Sat, 12 Jan 2008 14:06:51 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [TOMOYO #6 retry 08/21] Utility functions and policy
 manipulationinterface.
In-Reply-To: <200801121106.DBD21371.SVJOOHQFFLOFMt@I-love.SAKURA.ne.jp>
Message-ID: <Xine.LNX.4.64.0801121406310.2499@us.intercode.com.au>
References: <20080109005320.323184643@nttdata.co.jp> <20080109005421.598247963@nttdata.co.jp>
 <Xine.LNX.4.64.0801091524500.13216@us.intercode.com.au>
 <Xine.LNX.4.64.0801091528160.13216@us.intercode.com.au>
 <200801121106.DBD21371.SVJOOHQFFLOFMt@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Jan 2008, Tetsuo Handa wrote:

> Hello.
> 
> James Morris wrote:
> > > > TOMOYO Linux uses /sys/kernel/security/tomoyo interface for configuration.
> > > 
> > > Why aren't you using securityfs for this?  (It was designed for LSMs).
> > 
> > Doh, it is using securityfs, don't worry.
> > 
> I got a mm-commits mail titled
> "+ sysfs-make-sysfs_deprecated-depend-on-sysfs.patch added to -mm tree" .
> 
> Is sysfs going to be deprecated?

Unlikely -- what's in the patches?


- James
-- 
James Morris
<jmorris@namei.org>
