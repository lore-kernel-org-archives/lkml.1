Return-Path: <linux-kernel-owner+w=401wt.eu-S1756615AbXGWMjI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756615AbXGWMjI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 08:39:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752395AbXGWMi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 08:38:57 -0400
Received: from il.qumranet.com ([82.166.9.18]:49034 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752242AbXGWMi4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 08:38:56 -0400
Message-ID: <46A4A16A.3080908@qumranet.com>
Date: Mon, 23 Jul 2007 15:39:06 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>, Avi Kivity <avi@qumranet.com>,
       Shaohua Li <shaohua.li@intel.com>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [kvm-devel] [RFC 0/8]KVM: swap out guest pages
References: <1185173489.2645.64.camel@sli10-conroe.sh.intel.com> <46A4829C.9080104@qumranet.com> <20070723122510.GA3674@infradead.org> <46A49F30.5010206@qumranet.com> <20070723123443.GB3674@infradead.org>
In-Reply-To: <20070723123443.GB3674@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
>
>> Generic vmas will be more intrusive AFAICT.
>>     
>
> People use intrusive differently.  Doing big changes to core code is not
> a problem if we actually get a proper interface.  Just exporting core
> function without other changes and then writing code in modules that
> pokes into internals is much much worse.
>   

Agree 100%.

-- 
error compiling committee.c: too many arguments to function

