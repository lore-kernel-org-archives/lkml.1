Return-Path: <linux-kernel-owner+w=401wt.eu-S965461AbXBFVAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965461AbXBFVAk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 16:00:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965465AbXBFVAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 16:00:40 -0500
Received: from terminus.zytor.com ([192.83.249.54]:53257 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965461AbXBFVAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 16:00:39 -0500
Message-ID: <45C8EC6B.8070504@zytor.com>
Date: Tue, 06 Feb 2007 13:00:27 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070102)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Etienne Lorrain <etienne_lorrain@yahoo.fr>, vgoyal@in.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: Re : Re : Re : [PATCH] Compressed ia32 ELF file generation for
 loading by Gujin 1/3
References: <199171.13576.qm@web26913.mail.ukl.yahoo.com> <m1ejp3ropj.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1ejp3ropj.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> 
>>  Modifying the linux real mode assembler, nobody could even want to.
> 
> I have several times.  It's just code.  But I do agree it will likely
> be more maintainable if we can convert it to C.
> 
> On that same token I wrote a compiler in romcc in another context so I
> didn't have to write so much assembly.  And for maintainability and
> comprehensibility it was a big help.
> 

I've long wished that someone would do a proper 16-bit x86 port of gcc; 
however, the .code16gcc is usually good enough, although it produces 
code which is a lot bigger than it needs to be.

	-hpa

