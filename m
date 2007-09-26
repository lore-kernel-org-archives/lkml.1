Return-Path: <linux-kernel-owner+w=401wt.eu-S1754129AbXIZXfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129AbXIZXfq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 19:35:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752294AbXIZXfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 19:35:39 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:34454 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbXIZXfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 19:35:38 -0400
Message-ID: <46FAECC5.8040103@davidnewall.com>
Date: Thu, 27 Sep 2007 09:05:33 +0930
From: David Newall <david@davidnewall.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Christer Weinigel <christer@weinigel.se>, Al Viro <viro@ftp.linux.org.uk>,
       Phillip Susi <psusi@cfl.rr.com>, Bill Davidsen <davidsen@tmr.com>,
       majkls <majkls@prepere.com>, linux-kernel@vger.kernel.org
Subject: Re: sys_chroot+sys_fchdir Fix
References: <46F16A0A.3070402@tmr.com> <20070919194559.36015307@the-village.bc.nu> <46F1A196.8060108@davidnewall.com> <46F401D6.6060609@cfl.rr.com> <20070921191012.15a0b51b@the-village.bc.nu> <46F9752C.5080807@cfl.rr.com> <20070926002340.GL8181@ftp.linux.org.uk> <46FA35A6.1070400@davidnewall.com> <20070926212408.6662231a@zoo.weinigel.se> <46FACCE0.2070005@davidnewall.com> <20070926215521.GU6800@stusta.de>
In-Reply-To: <20070926215521.GU6800@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> You are claiming "They went so far as to say that dot-dot wouldn't let 
> you out"?
>   

I phrased it in a somewhat conversational way.  The promise, which I've 
now quoted from multiple sources, is expressed variously, including:
> The dot-dot entry in the root directory is interpreted to mean the root directory itself. Thus, dot-dot cannot be used to access files outside the subtree rooted at the root directory.
>   
