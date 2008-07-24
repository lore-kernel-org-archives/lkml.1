Return-Path: <linux-kernel-owner+w=401wt.eu-S1756169AbYGXLlN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169AbYGXLlN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 07:41:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752491AbYGXLk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 07:40:56 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:27034 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbYGXLkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 07:40:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MUnkmoBN/JVQXjt9xmSiDYIEcY3NRCyTJtzU4zdndpIKdfntINRhK4tPHpvFSqqVUi
         T2tDp3kbXdMIfwiYCuXrGwaGD65PccirzKOoqzbZPmPj44OLnkmKqqX+B4rkyvVRbH2B
         gzEHdK87EEGd5dxJIl7vYjHs3pbvdG+2eK2m0=
Date: Thu, 24 Jul 2008 15:40:20 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, macro@linux-mips.org
Subject: Re: [patch 0/2] x86 apic - a few function merge
Message-ID: <20080724114020.GB3432@lenovo>
References: <488866b0.1636440a.2c8e.ffffa15c@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <488866b0.1636440a.2c8e.ffffa15c@mx.google.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Thu, Jul 24, 2008 at 03:22:41PM +0400]
|   I don't leave hope to merge APIC code someday (now it becomes harder
| 'cause of new x(2)APIC code). So these patches merges a few functions.
| No changes on binary level. Please review. Any comments are welcome!
| 
|   The patches are made on top of -tip tree
| 
| commit d55ee73e46e89547aca7ca83a2df80bf70d9d1d1
| Merge: 6a807a0... 695a6b4...
| Author: Ingo Molnar <mingo@elte.hu>
| Date:   Wed Jul 23 13:21:26 2008 +0200
| 
|     Merge branch 'cpus4096'
| 
| 		- Cyrill -
| -- 
| 

oh... sorry... my mail agent is screwed up

		- Cyrill -
