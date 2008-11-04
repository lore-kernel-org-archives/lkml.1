Return-Path: <linux-kernel-owner+w=401wt.eu-S1756088AbYKDP5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088AbYKDP5z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 10:57:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754629AbYKDP5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 10:57:31 -0500
Received: from nlpi025.sbcis.sbc.com ([207.115.36.54]:42234 "EHLO
	nlpi025.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754405AbYKDP53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 10:57:29 -0500
Date: Tue, 4 Nov 2008 09:56:29 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: rusty@rustcorp.com.au, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: Broken "cpualloc: the allocator" patch
In-Reply-To: <Pine.LNX.4.64.0811040934180.12886@quilx.com>
Message-ID: <Pine.LNX.4.64.0811040955530.12886@quilx.com>
References: <20081104034237.GA15227@x200.localdomain>
 <Pine.LNX.4.64.0811040934180.12886@quilx.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux-next also works fine.

christoph@JTCHITW00139:~$ uname -a
Linux JTCHITW00139 2.6.28-rc3-next-20081103 #1 SMP Tue Nov 4 09:51:42 CST 2008 x86_64 GNU/Linux

