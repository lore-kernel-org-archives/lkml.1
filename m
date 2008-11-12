Return-Path: <linux-kernel-owner+w=401wt.eu-S1752135AbYKMPW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135AbYKMPW4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 10:22:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751198AbYKMPWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 10:22:47 -0500
Received: from ti-out-0910.google.com ([209.85.142.187]:55201 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986AbYKMPWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 10:22:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=om5cbqNJdKOQBiajZq6OuT5viHv9Ps8maedoFu7jYoZavQO6O3XaAZSqYkxLmbMMs6
         YFTgyVGLnvLHt4BXgFTtBADvGSu+16LugX69uuDYkCkrFSKGzJ65Kie0oFHPJMFo4dzy
         uA+yKHM2i0fwqSQzL/rnHjycO8z6a8i3sZB5E=
Date: Thu, 13 Nov 2008 05:41:52 +0800
From: arrow.ebd@gmail.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: arrow.ebd@gmail.com, linux_kernel <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@linux.ie>
Subject: Re: thinkpad x200 X.server not work with gm4500 graphics
Message-ID: <20081112214152.GA4682@think>
References: <20081110152518.GA3545@think> <20081111004643.8f8608a3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20081111004643.8f8608a3.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2008 at 12:46:43AM -0800, Andrew Morton wrote:
> On Mon, 10 Nov 2008 23:25:18 +0800 arrow.ebd@gmail.com wrote:
> >     My thinkpad x200's X.server can not startup on the kernel 2.6.28,
> 
> Were any earlier kernels OK?  If so, which version(s)?
v2.6.27 work fine while v2.6.27-rc[1,2,3,4] do not work.
