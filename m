Return-Path: <linux-kernel-owner+w=401wt.eu-S1752833AbYCLTYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833AbYCLTYa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 15:24:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751752AbYCLTYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 15:24:21 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:41680 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751385AbYCLTYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 15:24:21 -0400
Date: Wed, 12 Mar 2008 14:24:14 -0500
From: Paul Jackson <pj@sgi.com>
To: "Paul Menage" <menage@google.com>
Cc: maxk@qualcomm.com, mingo@elte.hu, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org
Subject: Re: boot cgroup questions
Message-Id: <20080312142414.71c5731f.pj@sgi.com>
In-Reply-To: <6599ad830803121216y32b88d15r462aac437142d814@mail.gmail.com>
References: <47D73086.2030008@qualcomm.com>
	<6599ad830803111827n1cb8e2c7i47c2ef3f3bb58995@mail.gmail.com>
	<47D7411E.1000009@qualcomm.com>
	<6599ad830803111936jd940deam8584bc971c3b6f41@mail.gmail.com>
	<47D74595.4080100@qualcomm.com>
	<6599ad830803112009y18d9e43ft8e3fc4a551d891da@mail.gmail.com>
	<20080311235939.1ebee8e3.pj@sgi.com>
	<6599ad830803121216y32b88d15r462aac437142d814@mail.gmail.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul M wrote:
> Not cgroups, no. If you really wanted to extend cpusets specifically
> to allow irqs to be assigned to a cpuset to control which cpus they
> could execute on, then that might be a possibility. But I don't see
> how this would be useful for any other cgroup subsystem, so it doesn't
> belong in the generic framework.

Ok - a sensible decision.

> My feeling is that just using a simple bitmask assignment, unrelated
> to cpusets or cgroups, as Max suggested in his later email is the way
> to go.

I'll have to have another go at reading his replies.  I seem to have
more difficulty making sense of his posts ... not sure why.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
