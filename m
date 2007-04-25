Return-Path: <linux-kernel-owner+w=401wt.eu-S1754624AbXDYXlE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624AbXDYXlE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 19:41:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754623AbXDYXlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 19:41:04 -0400
Received: from gw.goop.org ([64.81.55.164]:44645 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754620AbXDYXlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 19:41:01 -0400
Message-ID: <462FE728.5060802@goop.org>
Date: Wed, 25 Apr 2007 16:41:28 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Chuck Ebbert <cebbert@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, lkml <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>, Chris Wright <chrisw@sous-sol.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 10/28] i386: map enough initial memory to create lowmem
 mappings
References: <20070414204154.871250608@goop.org>	<200704192250.52633.ak@suse.de> <4627D756.5020405@zytor.com>	<200704192304.01053.ak@suse.de> <4627DB0C.2010804@zytor.com>	<4627DDAD.4070805@redhat.com> <4627E099.209@goop.org>	<m1abwwqiof.fsf@ebiederm.dsl.xmission.com> <462FC8CD.1030505@goop.org>	<m11wi8qflo.fsf@ebiederm.dsl.xmission.com> <462FD0EF.5050706@goop.org>	<m1tzv4p079.fsf@ebiederm.dsl.xmission.com> <462FDBB4.8020604@goop.org> <m14pn4owpy.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m14pn4owpy.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Then why you had to allocate enough pages to cause a failure has me stumped.
> Perhaps there is some other bug?
>   

Perhaps, but nothing comes to mind. I'll see what happens when I boot
this kernel on real hardware (rather than kvm).

J
