Return-Path: <linux-kernel-owner+w=401wt.eu-S1760079AbYHECtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760079AbYHECtm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 22:49:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757801AbYHECte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 22:49:34 -0400
Received: from smtp102.prem.mail.sp1.yahoo.com ([98.136.44.57]:23645 "HELO
	smtp102.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757916AbYHECtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 22:49:33 -0400
X-YMail-OSG: lMFIElYVM1l4r97tpsf7bQoQBQ_8AvINkl8lTGlkyNUBwLlS_OYxloL384NvmYfSUxd7rYPqVGFqsOpdlI3HsUQC7LDjyq5xy6xuV0bqQX1pkctZMdSioRHgMdMjeSXmePU-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4897BFB4.9090309@schaufler-ca.com>
Date: Mon, 04 Aug 2008 19:49:24 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>
CC: malware-list@lists.printk.net, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [RFC 0/5] [TALPA] Intro to a linux interface for on access scanning
References: <1217883616.27684.19.camel@localhost.localdomain>
In-Reply-To: <1217883616.27684.19.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Paris wrote:
> Please contact me privately or (preferably the list) for questions,
> comments, discussions, flames, names, or anything.  I'll do complete
> rewrites of the patches if someone tells me how they don't meet their
> needs or how they can be done better.  I'm here to try to bridge the
> needs (and wants) of the anti-malware vendors with the technical
> realities of the kernel.  So everyone feel free to throw in your two
> cents and I'll try to reconcile it all.  These 5 patches are part 1.
> They give us a working able solution.
>
> >From my point of view patches forthcoming and mentioned below should
> help with performance for those who actually have userspace scanners but
> also could presents be implemented using this framework.
>
>   

The LSM list (CCed) should be included in this discussion.
> Background
> ...


