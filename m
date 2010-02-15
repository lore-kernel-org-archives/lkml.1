Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239Ab0BOEfk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 23:35:40 -0500
Received: from cantor.suse.de ([195.135.220.2]:43240 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755100Ab0BOEfi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 23:35:38 -0500
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH v2] Make VM_MAX_READAHEAD a kernel parameter
Date: Mon, 15 Feb 2010 10:05:05 +0530
User-Agent: KMail/1.12.2 (Linux/2.6.31.8-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: Ankit Jain <radical@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
References: <201002091659.27037.knikanth@suse.de> <201002111715.04411.knikanth@suse.de> <20100211151651.GA8753@localhost>
In-Reply-To: <20100211151651.GA8753@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002151005.05923.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 February 2010 20:46:51 Wu Fengguang wrote:
> Nikanth,
> 
> > From: Nikanth Karthikesan <knikanth@suse.de>
> >
> > Add new kernel parameter "readahead", which would be used instead of the
> > value of VM_MAX_READAHEAD. If the parameter is not specified, the default
> > of 128kb would be used.
> 
> The patch looks good to me, though it conflicts with my patches.
> Do you mind me including a modified version in my readahead patchset?
> 

Sure, go ahead.

Thanks
Nikanth
