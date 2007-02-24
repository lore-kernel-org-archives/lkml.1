Return-Path: <linux-kernel-owner+w=401wt.eu-S933365AbXBXEGF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933365AbXBXEGF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 23:06:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933363AbXBXEGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 23:06:05 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:46977 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933365AbXBXEGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 23:06:04 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Jeff V. Merkey" <jmerkey@wolfmountaingroup.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Conclusions from my investigation about ioapic programming
References: <200701221116.13154.luigi.genoni@pirelli.com>
	<200702021905.39922.luigi.genoni@pirelli.com>
	<m1zm7w3wvr.fsf_-_@ebiederm.dsl.xmission.com>
	<m1veik3woc.fsf_-_@ebiederm.dsl.xmission.com>
	<20070206073616.GA15016@elte.hu>
	<m1odo7q6cq.fsf@ebiederm.dsl.xmission.com>
	<20070206222523.GA11602@elte.hu>
	<m1irecamzh.fsf@ebiederm.dsl.xmission.com>
	<m1wt2s8ksa.fsf@ebiederm.dsl.xmission.com>
	<m1veib6dgi.fsf@ebiederm.dsl.xmission.com>
	<m1hctt1sfp.fsf_-_@ebiederm.dsl.xmission.com>
	<Pine.LNX.4.64.0702102146380.8245@montezuma.fsmlabs.com>
	<m13b5d0zdp.fsf@ebiederm.dsl.xmission.com>
	<Pine.LNX.4.64.0702110753390.8245@montezuma.fsmlabs.com>
	<m17iuoz74f.fsf@ebiederm.dsl.xmission.com>
	<Pine.LNX.4.64.0702111416220.24829@montezuma.fsmlabs.com>
	<m1r6swx9l2.fsf@ebiederm.dsl.xmission.com>
	<m1irdtw3jb.fsf_-_@ebiederm.dsl.xmission.com>
	<45DF1ADD.9000600@wolfmountaingroup.com>
	<m13b4wu4m8.fsf@ebiederm.dsl.xmission.com>
	<45DF28D7.5010303@wolfmountaingroup.com>
Date: Fri, 23 Feb 2007 21:05:41 -0700
In-Reply-To: <45DF28D7.5010303@wolfmountaingroup.com> (Jeff V. Merkey's
	message of "Fri, 23 Feb 2007 10:48:07 -0700")
Message-ID: <m18xeoryi2.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Jeff V. Merkey" <jmerkey@wolfmountaingroup.com> writes:

> Eric,
>
> Please find attached the APIC code I used in Gadugi. It's code for plain vanilla
> APICs, but does just this. This code not only allows
> interrupts to be migrated, but processors to be stopped and restarted on the fly
> without system interruption. You may find some useful
> ideas in it.

Just for clarification.  Who owns the code you posted. What is the
copyright license on it?  Or do you own the copyright and place it
into the public domain?

Eric

