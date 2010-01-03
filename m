Return-Path: <linux-kernel-owner+w=401wt.eu-S1753069Ab0ACRkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069Ab0ACRkJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 12:40:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753018Ab0ACRkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 12:40:07 -0500
Received: from mail-px0-f174.google.com ([209.85.216.174]:54309 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898Ab0ACRkF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 12:40:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=nKnqBUZK1ZBb8lJTeXd84eD9ZB+ne1pIdbrD53JcGy+ehO4sKVCRtRF2eaSu+nrmeF
         wcZAuVLGtc4FyAOCyHNK+/S0rafaEvVXBGouAgxKkAs2hBkaAXFKu/1rl32wmQzNYNXP
         VAK8IPc46sxGqm5DS3NsW5verpaGCJ3TMAB7E=
MIME-Version: 1.0
In-Reply-To: <20100103092608.0a04c664@infradead.org>
References: <daef60381001030705r93b3fbfkc50e7b9bbc62b334@mail.gmail.com> 
	<20100103160313.GA21156@n2100.arm.linux.org.uk> <daef60381001030830u176c0cfavbb31358a2b42ed60@mail.gmail.com> 
	<20100103164414.GB21156@n2100.arm.linux.org.uk> <daef60381001030855o3a39c3fdr879e2634fb85c491@mail.gmail.com> 
	<20100103092608.0a04c664@infradead.org>
From: Hui Zhu <teawater@gmail.com>
Date: Mon, 4 Jan 2010 01:39:44 +0800
Message-ID: <daef60381001030939r60315c1dy56025a041a8ee758@mail.gmail.com>
Subject: Re: [PATCH] stack2core: show stack message and convert it to core 
	file when kernel die
To: Arjan van de Ven <arjan@infradead.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       saeed bishara <saeed.bishara@gmail.com>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Nicolas Pitre <nico@fluxnic.net>, Ralf Baechle <ralf@linux-mips.org>,
       David Daney <ddaney@caviumnetworks.com>, Chris Dearman <chris@mips.com>,
       Paul Gortmaker <Paul.Gortmaker@windriver.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, Brian Gerst <brgerst@gmail.com>,
       Tejun Heo <tj@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org, Coly Li <coly.li@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

scripts/markup_oops.pl just support x86?
s2c support x86, x8664, arm, mips, mips64.

Thanks,
Hui

On Mon, Jan 4, 2010 at 01:26, Arjan van de Ven <arjan@infradead.org> wrote:
> On Mon, 4 Jan 2010 00:55:04 +0800
> Hui Zhu <teawater@gmail.com> wrote:
>>
>> It show which line make kernel die.
>>
>
> similar to scripts/markup_oops.pl already does ?
>
>
> --
> Arjan van de Ven        Intel Open Source Technology Centre
> For development, discussion and tips for power savings,
> visit http://www.lesswatts.org
>
