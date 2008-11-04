Return-Path: <linux-kernel-owner+w=401wt.eu-S1754945AbYKDPjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945AbYKDPjt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 10:39:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753579AbYKDPjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 10:39:40 -0500
Received: from nlpi025.sbcis.sbc.com ([207.115.36.54]:41158 "EHLO
	nlpi025.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895AbYKDPjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 10:39:39 -0500
Date: Tue, 4 Nov 2008 09:38:40 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: rusty@rustcorp.com.au, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: Broken "cpualloc: the allocator" patch
In-Reply-To: <20081104034237.GA15227@x200.localdomain>
Message-ID: <Pine.LNX.4.64.0811040934180.12886@quilx.com>
References: <20081104034237.GA15227@x200.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Works fine here.

Do we have the right tree? I repulled my tree on top of Linuses and things 
work just fine. Tree is at

kernel.org/pub/scm/linux/kernel/git/christoph/work.git cpu_alloc


I'll have a look at what exactly is in -next next.
