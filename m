Return-Path: <linux-kernel-owner+w=401wt.eu-S1753195AbYJOIaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195AbYJOIaL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 04:30:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751454AbYJOI36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 04:29:58 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:33271 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbYJOI35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 04:29:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=ApSu2F/u/YyLx6kM8jKhWb9MyrHmQzUSHiepZ/F9VdO10aUwCPPhNCMr8xMq/upaHD
         Blx6FBhutWJWf4X6RWMfZFm3GBi6GG/TzuElchq32bWyrgX88rMGPTbvJ6Xl4jmdv3Ab
         5hSheDDlB3EcYo268L2R3C93xzBAodrMlDnu4=
Message-ID: <48F5A9FF.2020306@tuffmail.co.uk>
Date: Wed, 15 Oct 2008 09:29:51 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: "Wildman, Tom" <tom.wildman@hp.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "alan@redhat.com" <alan@redhat.com>
Subject: Re: Superpages Project  -  sourceforge.net/projects/linuxsuperpages
References: <F9E7AD49A6823D4AA5A36E1DE32F0F9B27570B8CBC@GVW1092EXB.americas.hpqcorp.net>
In-Reply-To: <F9E7AD49A6823D4AA5A36E1DE32F0F9B27570B8CBC@GVW1092EXB.americas.hpqcorp.net>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wildman, Tom wrote:
> A new project has been created at SourceForge with an implementation of the Rice University's Superpages FreeBSD prototype that has been ported to the 2.6 Linux kernel for IA64, x86-64, and x86-32.
>
> The project can be found at:  http://sourceforge.net/projects/linuxsuperpages
>   

Maybe I'm just struggling with the re-designed Sourceforge, but I can't
find a link to the "Wiki section" mentioned in the summary.

> The major benefit of supporting Superpages is increased memory reach of the processor's TLB, which reduces the number of TLB misses in applications that have large data sets.  Some benchmarks have been improved 20% in execution time.
>
> Reference www.cs.rice.edu/~jnavarro/superpages/ for more information about the Rice University's Superpages project.
>
> The project is being made available to the Open Source community to share the implementation and knowledge.  With the enhancements to the x86 architectures to support multiple and large page sizes there should be increased interest in this functionality.
>
> /Tom
>   

