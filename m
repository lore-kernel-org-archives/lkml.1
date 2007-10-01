Return-Path: <linux-kernel-owner+w=401wt.eu-S1755391AbXJAPHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391AbXJAPHr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 11:07:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752182AbXJAPHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 11:07:40 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43320 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751904AbXJAPHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 11:07:39 -0400
Date: Mon, 1 Oct 2007 08:07:05 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: James Morris <jmorris@namei.org>
cc: Andrew Morton <akpm@linux-foundation.org>, casey@schaufler-ca.com,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Version 3 (2.6.23-rc8) Smack: Simplified Mandatory Access
 Control Kernel
In-Reply-To: <Xine.LNX.4.64.0710010146100.13671@us.intercode.com.au>
Message-ID: <alpine.LFD.0.999.0710010803280.3579@woody.linux-foundation.org>
References: <46FEEBD4.5050401@schaufler-ca.com> <20070930011618.ccb8351b.akpm@linux-foundation.org>
 <Xine.LNX.4.64.0710010146100.13671@us.intercode.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 1 Oct 2007, James Morris wrote:
> 
> Merging Smack, however, would lock the kernel into the LSM API.  
> Presently, as SELinux is the only in-tree user, LSM can still be removed.

Hell f*cking NO!

You security people are insane. I'm tired of this "only my version is 
correct" crap. The whole and only point of LSM was to get away from that.

And anybody who claims that there is "consensus" on SELinux is just in 
denial.

People are arguing against other peoples security on totally bogus points. 
First it was AppArmor, now this.

I guess I have to merge AppArmor and SMACK just to get this *disease* off 
the table. You're acting like a string theorist, claiming that t here is 
no other viable theory out there. Stop it. It's been going on for too damn 
long.

			Linus
