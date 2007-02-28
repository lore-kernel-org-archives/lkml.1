Return-Path: <linux-kernel-owner+w=401wt.eu-S1751477AbXB1RaO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751477AbXB1RaO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 12:30:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751529AbXB1RaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 12:30:14 -0500
Received: from mail.tmr.com ([64.65.253.246]:54126 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751477AbXB1RaN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 12:30:13 -0500
Message-ID: <45E5BC5F.4060208@tmr.com>
Date: Wed, 28 Feb 2007 12:31:11 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: =?ISO-8859-1?Q?Fernando_Luis_V=E1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, ak@suse.de,
       akpm@linux-foundation.org
Subject: Re: [PATCH] affinity is not defined in non-smp kernels - i386
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org>	<1172646816.29709.15.camel@sebastian.intellilink.co.jp> <m1wt22iw1z.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1wt22iw1z.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Fernando Luis Vázquez Cao <fernando@oss.ntt.co.jp> writes:
> 
>> Initialize affinity only when building SMP kernels.
> 
> Reasonable.  I goofed here.
> 
> However I would prefer my patch that just deletes these problem lines.
> These lines don't really contribute anything and are harmless to
> remove.

Where is the initialization performed, then?

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

