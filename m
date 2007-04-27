Return-Path: <linux-kernel-owner+w=401wt.eu-S1756042AbXD0P4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042AbXD0P4k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 11:56:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756041AbXD0P4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 11:56:39 -0400
Received: from terminus.zytor.com ([192.83.249.54]:48951 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756040AbXD0P4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 11:56:38 -0400
Message-ID: <46321D2E.7000400@zytor.com>
Date: Fri, 27 Apr 2007 08:56:30 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Michael McConnell <soruk@eridani.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: MAINTAINERS file out of date?
References: <4631255F.9010902@eridani.co.uk> <m1647ijvk1.fsf@ebiederm.dsl.xmission.com> <4631873B.1000107@zytor.com> <200704271234.32679.ak@suse.de>
In-Reply-To: <200704271234.32679.ak@suse.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> A lot of that code (although, of course, not all) could be written in C,
>> though.  I'm thinking of taking a stab at rewriting it that way.
> 
> That would require a new compiler, right? I don't think that would
> make users very happy.
> 
> Besides the code is not exactly that maintenance intensive and only
> changes rarely so I don't need a pressing need to rewrite it

No, it would not need a new compiler.  All it requires is gcc plus a
reasonably recent binutils which you need anyway.

	-hpa
