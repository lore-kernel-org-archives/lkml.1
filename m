Return-Path: <linux-kernel-owner+w=401wt.eu-S1760875AbYHOUmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760875AbYHOUmy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 16:42:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753723AbYHOUmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 16:42:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54512 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752212AbYHOUmo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 16:42:44 -0400
Message-ID: <48A5E986.2040201@redhat.com>
Date: Fri, 15 Aug 2008 16:39:34 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, jbarnes@virtuousgeek.org,
       joro@8bytes.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH]: PCI: GART iommu alignment fixes [v2]
References: <4899B611.4070408@redhat.com> <200808071003.47326.jbarnes@virtuousgeek.org> <489B33D4.1080107@redhat.com> <20080809125116H.fujita.tomonori@lab.ntt.co.jp> <20080815161629.GL27955@elte.hu> <20080815180048.GA26844@elte.hu>
In-Reply-To: <20080815180048.GA26844@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>
> on an AMD X2 testsystem. (Asus board) Can send more info on request. 
> Config is:
>
>   http://redhat.com/~mingo/misc/config-Fri_Aug_15_18_30_56_CEST_2008.bad
>
> Any idea why that is so? Apparently the alignment change wasnt as benign 
> as assumed.
>
>   

Ingo, can you please send me details on the system?  I'll try to track 
it down.

P.

> 	Ingo
>   
