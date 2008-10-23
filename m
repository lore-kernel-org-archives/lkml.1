Return-Path: <linux-kernel-owner+w=401wt.eu-S1753952AbYJWFfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952AbYJWFfR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 01:35:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752088AbYJWFfD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 01:35:03 -0400
Received: from ozlabs.org ([203.10.76.45]:43784 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752069AbYJWFfC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 01:35:02 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mike Travis <travis@sgi.com>
Subject: Re: [PATCH 34/35] cpumask: Use accessors code. From: Rusty Russell <rusty@rustcorp.com.au>
Date: Thu, 23 Oct 2008 16:34:40 +1100
User-Agent: KMail/1.9.10
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <20081023020826.051012000@polaris-admin.engr.sgi.com> <20081023020833.097412000@polaris-admin.engr.sgi.com>
In-Reply-To: <20081023020833.097412000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810231634.41215.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 23 October 2008 13:09:00 Mike Travis wrote:
> Use the accessors rather than frobbing bits directly.  Most of this is
> in arch code I haven't even compiled, but it is mostly straightforward.

OK, FYI this one isn't for this merge window: I'll be splitting it and sending 
it via the various arch maintainers.

Also, I think a \n got lost, looking at the subject :)

Cheers,
Rusty.
