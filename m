Return-Path: <linux-kernel-owner+w=401wt.eu-S965778AbXCPRip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965778AbXCPRip (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 13:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965768AbXCPRip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 13:38:45 -0400
Received: from gw.goop.org ([64.81.55.164]:53700 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965778AbXCPRin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 13:38:43 -0400
Message-ID: <45FAD622.2080306@goop.org>
Date: Fri, 16 Mar 2007 10:38:42 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
       linux-arch@vger.kernel.org
Subject: Re: [patch 08/26] Xen-paravirt_ops: add hooks to intercept mm creation
 and destruction
References: <20070301232443.195603797@goop.org> <20070301232527.110592372@goop.org> <20070316093016.GP23174@elte.hu>
In-Reply-To: <20070316093016.GP23174@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> Add hooks to allow a paravirt implementation to track the lifetime of 
>> an mm.
>>     
>
> (i guess this one should be merged with the ARCH-define cleanup patch)
>   

Already done.  In fact, I think I did it before the last patch post. 
Are you looking at an uptodate series of patches?

   
