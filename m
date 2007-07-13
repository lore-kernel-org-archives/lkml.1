Return-Path: <linux-kernel-owner+w=401wt.eu-S1752143AbXGMEmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143AbXGMEmg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 00:42:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758140AbXGMEmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 00:42:21 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:5204 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758071AbXGMEmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 00:42:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rGO0ZO4dbucwLadbJ9rAUF0BvF5YIj9yF4qZtR0oTOR+wfvWouGeNAxb1rJSL2hLHu2nChUbi2/D1cuimzsJDMYla0mZ4P1zc9jgqrkVh5W5T9CQ/4I2O/8VLyPlIk/z0GGbrL/zUCI/12k+BMlHuvJHWLPgmmT8c0AUqAoV9Cs=
Message-ID: <86802c440707122142t796aaf29v46403cc50c7ba4ea@mail.gmail.com>
Date: Thu, 12 Jul 2007 21:42:12 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: [PATCH] try parent numa_node at first before using default
Cc: "Cornelia Huck" <cornelia.huck@de.ibm.com>,
       "Stefan Richter" <stefanr@s5r6.in-berlin.de>,
       "Andrew Morton" <akpm@linux-foundation.org>, "Andi Kleen" <ak@suse.de>,
       rientjes@google.com, "Christoph Lameter" <clameter@sgi.com>,
       "Christoph Hellwig" <hch@infradead.org>,
       "David Miller" <davem@davemloft.net>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org
In-Reply-To: <20070713031622.GC2395@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200707101641.17672.yinghai.lu@sun.com>
	 <469610D4.70009@s5r6.in-berlin.de>
	 <20070712172310.4d662e1f@gondolin.boeblingen.de.ibm.com>
	 <200707121059.54320.yinghai.lu@sun.com>
	 <20070712183141.GB22471@kroah.com>
	 <86802c440707121206i3186fe9chba55fe2e5e5e4c5@mail.gmail.com>
	 <20070713031622.GC2395@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/12/07, Greg KH <greg@kroah.com> wrote:
>
> But you were not able to test USB, right?  Does that work properly now
> with this patch?

Will test it later with USB cdrom by big file reading.

YH
