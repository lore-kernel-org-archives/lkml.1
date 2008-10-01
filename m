Return-Path: <linux-kernel-owner+w=401wt.eu-S1754268AbYJAVLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268AbYJAVLX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 17:11:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753189AbYJAVLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 17:11:16 -0400
Received: from gate.crashing.org ([63.228.1.57]:38977 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753066AbYJAVLQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 17:11:16 -0400
Cc: Jon Tollefson <kniht@linux.vnet.ibm.com>,
       linuxppc-dev <linuxppc-dev@ozlabs.org>,
       Adam Litke <agl@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>
Message-Id: <7E5B6DFB-F9DE-4929-8A4F-8011BF817017@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Adam Litke <agl@us.ibm.com>
In-Reply-To: <1222789675.13978.14.camel@localhost.localdomain>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: [PATCH] properly reserve in bootmem the lmb reserved regions that cross numa nodes
Date: Wed, 1 Oct 2008 16:02:33 -0500
References: <48E23D6C.4030406@linux.vnet.ibm.com> <1222789675.13978.14.camel@localhost.localdomain>
X-Mailer: Apple Mail (2.929.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Out of interest how to do you guys represent NUMA regions of memory in  
the device tree?

- k
