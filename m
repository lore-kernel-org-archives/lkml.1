Return-Path: <linux-kernel-owner+w=401wt.eu-S2992715AbXBISKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992715AbXBISKj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 13:10:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992724AbXBISKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 13:10:39 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:51757 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992715AbXBISKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 13:10:38 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, Ingo Molnar <mingo@elte.hu>,
       tglx@linutronix.de, linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       James Morris <jmorris@namei.org>
Subject: Re: [PATCH 0/5] sysctl cleanup selinux fixes
References: <200701280106.l0S16CG3019873@shell0.pdx.osdl.net>
	<20070127172410.2b041952.akpm@osdl.org>
	<1169972718.17469.164.camel@localhost.localdomain>
	<20070128003549.2ca38dc8.akpm@osdl.org>
	<20070128093358.GA2071@elte.hu> <20070128095712.GA6485@elte.hu>
	<20070128100627.GA8416@elte.hu>
	<20070128104548.a835d859.akpm@osdl.org>
	<m1r6tfq7nv.fsf_-_@ebiederm.dsl.xmission.com>
	<1170075866.8720.15.camel@moss-spartans.epoch.ncsc.mil>
	<m17iuvrnpk.fsf_-_@ebiederm.dsl.xmission.com>
	<m13b5jrngt.fsf_-_@ebiederm.dsl.xmission.com>
	<1170872654.11912.87.camel@moss-spartans.epoch.ncsc.mil>
	<1170882738.11912.144.camel@moss-spartans.epoch.ncsc.mil>
	<m17iutmmwh.fsf@ebiederm.dsl.xmission.com>
	<1170946871.11912.250.camel@moss-spartans.epoch.ncsc.mil>
	<m14ppwa64j.fsf@ebiederm.dsl.xmission.com>
	<1170958404.11912.313.camel@moss-spartans.epoch.ncsc.mil>
	<m1mz3o8fbf.fsf@ebiederm.dsl.xmission.com>
	<m1abzo8dr0.fsf_-_@ebiederm.dsl.xmission.com>
	<20070209030504.2c30b309.akpm@linux-foundation.org>
Date: Fri, 09 Feb 2007 11:09:37 -0700
In-Reply-To: <20070209030504.2c30b309.akpm@linux-foundation.org> (Andrew
	Morton's message of "Fri, 9 Feb 2007 03:05:04 -0800")
Message-ID: <m164ab5hjy.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Thu, 08 Feb 2007 15:51:15 -0700 ebiederm@xmission.com (Eric W. Biederman)
> wrote:
>
>> Patch 3: sysctl: Fix selinux_sysctl_getsid
>> This is a small fix against
>> "sysctl: Restore the old selinux sysctl handling."
>> 
>
> I cannot locate such a patch.  I just gave up and plastered
> the fixes at end-of-series.

Ok.  Sorry.  I'm guessing one of us (probably me) renamed that one.  I have
this habit of rewriting my comments as they go out the door, so they are
more readable.

Eric


