Return-Path: <linux-kernel-owner+w=401wt.eu-S1752036AbXIPHXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036AbXIPHXX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 03:23:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751274AbXIPHXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 03:23:16 -0400
Received: from smtpoutm.mac.com ([17.148.16.77]:58262 "EHLO smtpoutm.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281AbXIPHXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 03:23:15 -0400
In-Reply-To: <1189855141.21778.307.camel@twins>
References: <C2A8AED2-363F-4131-863C-918465C1F4E1@cam.ac.uk> <1189850897.21778.301.camel@twins> <C9A68AAE-0B37-4BB5-A9E6-66C186566940@cam.ac.uk> <1189855141.21778.307.camel@twins>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <EF4D78B7-DCE2-49E7-B31E-AB9A9B7F7609@mac.com>
Cc: Anton Altaparmakov <aia21@cam.ac.uk>, marc.smith@esmail.mcc.edu,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: VM/VFS bug with large amount of memory and file systems?
Date: Sun, 16 Sep 2007 03:22:11 -0400
To: Peter Zijlstra <peterz@infradead.org>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 15, 2007, at 07:19:01, Peter Zijlstra wrote:
> On Sat, 2007-09-15 at 11:50 +0100, Anton Altaparmakov wrote:
>> I haven't word wrapped it at all.  The lines appear as whole lines  
>> in Apple Mail (my email client).  It must be your email client  
>> that is wrapping them...
>
> Oddly, this line is still long in Andrew's reply but wrapped in  
> yours.  Must be some odd mailer interaction.

Actually Apple Mail.app sends format=flowed wrapped to 73  
characters.  So a wrapped line has a single space character right  
before each 'wrapping' newline.  If your mail client supports  
format=flowed viewing and sends without format=flowed (like AKPM's  
mailer appears to), then it will properly unwrap the lines and resend  
without the wrapping.  Mailers which *DONT* support format=flowed  
will see the wrapped version.  Normally this is what you want but  
it's a PITA for patches and logfiles.

I believe with Mail.app if you attach a .txt file it will be  
unmangled and sent as "Content-Type: text/plain" and "Content- 
Disposition: inline", so most email-clients will display it as part  
of the message.

Cheers,
Kyle Moffett

