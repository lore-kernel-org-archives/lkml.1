Return-Path: <linux-kernel-owner+w=401wt.eu-S1751548AbXCVGgI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751548AbXCVGgI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 02:36:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752217AbXCVGgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 02:36:08 -0400
Received: from www.cosmosbay.com ([86.65.150.131]:46131 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751548AbXCVGgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 02:36:05 -0400
Date: Thu, 22 Mar 2007 07:35:36 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
To: Maxim <maximlevitsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Andi Kleen <ak@suse.de>,
       David Howells <dhowells@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] : Is /proc/kcore still usefull and/or maintained ?
Message-Id: <20070322073536.0fce422a.dada1@cosmosbay.com>
In-Reply-To: <200703220204.51146.maximlevitsky@gmail.com>
References: <200703211840.53242.maximlevitsky@gmail.com>
	<200703220128.18610.maximlevitsky@gmail.com>
	<20070322005310.03be8637.dada1@cosmosbay.com>
	<200703220204.51146.maximlevitsky@gmail.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Thu, 22 Mar 2007 07:35:41 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Mar 2007 02:04:50 +0200
Maxim <maximlevitsky@gmail.com> wrote:


> Hi,
> 	Yes, you are right, you have different problem that I had
> 
> 	But why do you need llseek ?

I dont personnaly, but tools do need llseek.

> 
> 	Why not to mmap it ?
> 	It is natural thing to do with files that represent memory.

Because I dont want to rewrite gdb, file, and other various tools ?

