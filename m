Return-Path: <linux-kernel-owner+w=401wt.eu-S1753012AbXD0FZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012AbXD0FZW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 01:25:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755145AbXD0FZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 01:25:22 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:42570 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012AbXD0FZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 01:25:15 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Michael McConnell <soruk@eridani.co.uk>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>
Subject: Re: MAINTAINERS file out of date?
References: <4631255F.9010902@eridani.co.uk> <463131FD.8020301@zytor.com>
	<20070427010914.GA2570@localhost.localdomain>
	<46314E0B.1020800@zytor.com>
	<20070427023252.GA3797@localhost.localdomain>
	<m1647ijvk1.fsf@ebiederm.dsl.xmission.com>
	<4631873B.1000107@zytor.com>
Date: Thu, 26 Apr 2007 23:24:13 -0600
In-Reply-To: <4631873B.1000107@zytor.com> (H. Peter Anvin's message of "Thu,
	26 Apr 2007 22:16:43 -0700")
Message-ID: <m1tzv2ie4i.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> A lot of that code (although, of course, not all) could be written in C,
> though.  I'm thinking of taking a stab at rewriting it that way.

Is this using the .code16gcc?  Or are you thinking of some other
technique.  Requiring another C compiler to build the kernel would
be a pain to use.

Eric
