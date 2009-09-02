Return-Path: <linux-kernel-owner+w=401wt.eu-S1751918AbZIBLpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918AbZIBLpf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 07:45:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751775AbZIBLpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 07:45:35 -0400
Received: from lucidpixels.com ([75.144.35.66]:49815 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689AbZIBLpe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 07:45:34 -0400
Date: Wed, 2 Sep 2009 07:45:36 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Christoph Hellwig <hch@infradead.org>
cc: Nikanth Karthikesan <knikanth@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: Kernel 2.6.30.4 loop(..?) regression (& with/2.6.31-rc6)
In-Reply-To: <alpine.DEB.2.00.0908280720220.30806@p34.internal.lan>
Message-ID: <alpine.DEB.2.00.0909020743550.22337@p34.internal.lan>
References: <alpine.DEB.2.00.0908221044420.30321@p34.internal.lan> <20090822201558.GA17955@infradead.org> <alpine.DEB.2.00.0908221645440.20848@p34.internal.lan> <20090822205502.GA18904@infradead.org> <alpine.DEB.2.00.0908221659030.23463@p34.internal.lan>
 <20090823224504.GA19942@infradead.org> <alpine.DEB.2.00.0908240704130.9427@p34.internal.lan> <alpine.DEB.2.00.0908260949550.9396@p34.internal.lan> <20090826180234.GC14019@infradead.org> <alpine.DEB.2.00.0908261717001.1594@p34.internal.lan>
 <20090826212732.GA18124@infradead.org> <alpine.DEB.2.00.0908261728580.1594@p34.internal.lan> <alpine.DEB.2.00.0908280720220.30806@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 28 Aug 2009, Justin Piszcz wrote:
>
> On Wed, 26 Aug 2009, Justin Piszcz wrote:
>
>> On Wed, 26 Aug 2009, Christoph Hellwig wrote:
>> 
>>> On Wed, Aug 26, 2009 at 05:19:11PM -0400, Justin Piszcz wrote:

Christoph,

Now 6 days without any problems using -o nobarrier.

$ uptime
  07:43:55 up 6 days, 14:12,  1 user,  load average: 0.00, 0.00, 0.00

So -o nobarrier is a workaround for the issue.  How / what debug settings
should be enabled to catch the bug/problem when -o nobarrier is used?

Justin.
