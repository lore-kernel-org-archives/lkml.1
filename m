Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759023Ab0BYPA7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 10:00:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46550 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755450Ab0BYPA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 10:00:57 -0500
Message-ID: <4B869034.8010305@redhat.com>
Date: Thu, 25 Feb 2010 09:59:00 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Ankit Jain <radical@gmail.com>,
       Dave Chinner <david@fromorbit.com>,
       Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
       Nikanth Karthikesan <knikanth@suse.de>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Clemens Ladisch <clemens@ladisch.de>,
       Olivier Galibert <galibert@pobox.com>, Vivek Goyal <vgoyal@redhat.com>,
       Matt Mackall <mpm@selenic.com>, Nick Piggin <npiggin@suse.de>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/15] readahead: make default readahead size a kernel
 parameter
References: <20100224031001.026464755@intel.com> <20100224031054.161214875@intel.com>
In-Reply-To: <20100224031054.161214875@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2010 10:10 PM, Wu Fengguang wrote:
> From: Nikanth Karthikesan<knikanth@suse.de>
>
> Add new kernel parameter "readahead", which allows user to override
> the static VM_MAX_READAHEAD=512kb.
>
> CC: Ankit Jain<radical@gmail.com>
> CC: Dave Chinner<david@fromorbit.com>
> CC: Christian Ehrhardt<ehrhardt@linux.vnet.ibm.com>
> Signed-off-by: Nikanth Karthikesan<knikanth@suse.de>
> Signed-off-by: Wu Fengguang<fengguang.wu@intel.com>

Acked-by: Rik van Riel <riel@redhat.com>

