Return-Path: <linux-kernel-owner+w=401wt.eu-S1752029AbXDZAyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029AbXDZAyr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 20:54:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753805AbXDZAyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 20:54:46 -0400
Received: from gw.goop.org ([64.81.55.164]:34372 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752029AbXDZAyp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 20:54:45 -0400
Message-ID: <462FF879.10206@goop.org>
Date: Wed, 25 Apr 2007 17:55:21 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Chuck Ebbert <cebbert@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, lkml <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 10/28] i386: map enough initial memory to create lowmem
 mappings
References: <4627DDAD.4070805@redhat.com> <4627E099.209@goop.org> <m1abwwqiof.fsf@ebiederm.dsl.xmission.com> <462FC8CD.1030505@goop.org> <m11wi8qflo.fsf@ebiederm.dsl.xmission.com> <462FD0EF.5050706@goop.org> <m1tzv4p079.fsf@ebiederm.dsl.xmission.com> <462FDBB4.8020604@goop.org> <m14pn4owpy.fsf@ebiederm.dsl.xmission.com> <462FE728.5060802@goop.org> <20070426003337.GB2819@sequoia.sous-sol.org>
In-Reply-To: <20070426003337.GB2819@sequoia.sous-sol.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Wright wrote:
> I was using real hardware with your .config when I reproduced it.
>   

Yes, I first found it on real hardware. I haven't tested my fix on real
hardware yet, but it seems OK on kvm.

J
