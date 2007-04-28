Return-Path: <linux-kernel-owner+w=401wt.eu-S1752969AbXD1XZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969AbXD1XZ3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 19:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875AbXD1XZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 19:25:29 -0400
Received: from gw.goop.org ([64.81.55.164]:37576 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752548AbXD1XZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 19:25:03 -0400
Message-ID: <4633D7D5.4050404@goop.org>
Date: Sat, 28 Apr 2007 16:25:09 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andi Kleen <ak@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86: fix PSE pagetable construction
References: <4632AE54.7030200@goop.org>	<m1zm4tghyf.fsf@ebiederm.dsl.xmission.com>	<200704281229.48597.ak@suse.de> <46335A26.4020109@goop.org> <m1bqh8friu.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1bqh8friu.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Except for Xen my patch should work incrementally.

Yes, your patch is good.  I have it in my series followed by the
appropriate Xen patch, and it boots OK both Xen and native.

    J

