Return-Path: <linux-kernel-owner+w=401wt.eu-S1757214AbZCLTcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757214AbZCLTcQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 15:32:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753999AbZCLTb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 15:31:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56607 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675AbZCLTb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 15:31:58 -0400
Message-ID: <49B96273.7030301@zytor.com>
Date: Thu, 12 Mar 2009 12:28:51 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: linux-tip-commits@vger.kernel.org, mingo@redhat.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [tip:x86/setup] x86: remove zImage support
References: <49B703D4.1000008@zytor.com>	 <tip-5e47c478b0b69bc9bc3ba544e4b1ca3268f98fef@git.kernel.org> <1236879901.24144.26.camel@test.thuisdomein>
In-Reply-To: <1236879901.24144.26.camel@test.thuisdomein>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Bolle wrote:
> 
> Shouldn't the zImage target (and therefore the compressed, zlilo, and
> zdisk targets) also be dropped from arch/x86/Makefile?
> 

Forget what I asaid in the previous email; I had forgotten the ugly
hacks in arch/x86/Makefile, which is even more reason to get rid of this
crap ;)  You were right, of course :)

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

