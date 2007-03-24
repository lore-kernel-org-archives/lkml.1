Return-Path: <linux-kernel-owner+w=401wt.eu-S1753413AbXCXSHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbXCXSHW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 14:07:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753460AbXCXSHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 14:07:21 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:49745 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413AbXCXSHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 14:07:19 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-ide@vger.kernel.org
Subject: Re: [3/5] 2.6.21-rc4: known regressions (v2)
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
	<20070323185022.GQ752@stusta.de> <46055A3B.6050107@m3y3r.de>
Date: Sat, 24 Mar 2007 12:02:30 -0600
In-Reply-To: <46055A3B.6050107@m3y3r.de> (Thomas Meyer's message of "Sat, 24
	Mar 2007 18:04:59 +0100")
Message-ID: <m1slbu4j0p.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Meyer <thomas@m3y3r.de> writes:

> Adrian Bunk schrieb:
>> Subject    : second suspend to disk in a row results in an oops  (libata?)
>> References : http://lkml.org/lkml/2007/3/17/43
>> Submitter  : Thomas Meyer <thomas@m3y3r.de>
>> Status     : unknown
>>   
>
> The problem is identified: http://lkml.org/lkml/2007/3/22/150

Given the description above I'm a little confused.  Doesn't this
happen every time now?

Or was this happening only the second time before I started my msi
fixes... 

Eric
