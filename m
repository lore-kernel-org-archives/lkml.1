Return-Path: <linux-kernel-owner+w=401wt.eu-S1755521AbYFXLbG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521AbYFXLbG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 07:31:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751041AbYFXLax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 07:30:53 -0400
Received: from relay2.sgi.com ([192.48.171.30]:55516 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751617AbYFXLaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 07:30:52 -0400
Date: Tue, 24 Jun 2008 06:30:49 -0500
From: Paul Jackson <pj@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: tglx@linutronix.de, yhlu.kernel@gmail.com, steiner@sgi.com, travis@sgi.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org, ying.huang@intel.com,
       andi@firstfloor.org, akpm@linux-foundation.org
Subject: Re: [PATCH 0/5 v2] x86 boot: various E820 & EFI related fixes -
 what changed in v2
Message-Id: <20080624063049.428ad287.pj@sgi.com>
In-Reply-To: <20080624111903.GD8695@elte.hu>
References: <20080622142151.5591.4139.sendpatchset@polaris-admin.engr.sgi.com>
	<20080624111903.GD8695@elte.hu>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo wrote:
> applied to tip/x86/setup-memory, thanks Paul.

Thanks, Ingo.

> the review feedback from Peter still needs to be addressed

Agreed.  I like Huang's follow up suggestion to that as well:
> I think it is better to add a command-line flag "auxmem"

It seems to have better backward compatibility, as Huang states.

I'm tempted to name this kernel boot option "auxmemmap", since
I like having a little more specific name for this.

I will follow up with patches for these recommendations
of Peter and Huang.

Thanks, Peter and Huang, for the excellent feedback.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
