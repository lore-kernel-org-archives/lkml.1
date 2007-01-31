Return-Path: <linux-kernel-owner+w=401wt.eu-S1030556AbXAaT0G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030556AbXAaT0G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 14:26:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030560AbXAaT0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 14:26:05 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:47251 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030556AbXAaT0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 14:26:03 -0500
In-Reply-To: <20070131175118.GN1344@kvack.org>
References: <patchbomb.1170193181@tetsuo.zabbo.net> <1170209044.26655.364.camel@localhost.localdomain> <6CDD5D9D-E031-499D-9A8A-5A8522C66D37@oracle.com> <20070131175118.GN1344@kvack.org>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <FA6A1934-9D3D-456E-BDF6-3530D74BB657@oracle.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, linux-aio@kvack.org,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Transfer-Encoding: 7bit
From: Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH 0 of 4] Generic AIO by scheduling stacks
Date: Wed, 31 Jan 2007 11:25:30 -0800
To: Benjamin LaHaise <bcrl@kvack.org>
X-Mailer: Apple Mail (2.752.3)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> without linking it into the system lists.  The reason I don't think  
> this
> approach works (and I looked at it a few times) is that many things  
> end
> up requiring special handling: things like permissions, signals,  
> FPU state,
> segment registers....

Can you share a specific example of the special handling required?

- z
