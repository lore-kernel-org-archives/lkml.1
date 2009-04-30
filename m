Return-Path: <linux-kernel-owner+w=401wt.eu-S1764385AbZD3SEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764385AbZD3SEQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 14:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754996AbZD3SD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 14:03:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50502 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752832AbZD3SDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 14:03:55 -0400
Date: Thu, 30 Apr 2009 10:58:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Izik Eidus <ieidus@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
       avi@redhat.com, aarcange@redhat.com, chrisw@redhat.com,
       mtosatti@redhat.com, hugh@veritas.com
Subject: Re: [PATCH 5/5] add ksm kernel shared memory driver.
Message-Id: <20090430105828.3e248922.akpm@linux-foundation.org>
In-Reply-To: <20090430204624.358c4a2e@woof.tlv.redhat.com>
References: <1240191366-10029-1-git-send-email-ieidus@redhat.com>
	<1240191366-10029-2-git-send-email-ieidus@redhat.com>
	<1240191366-10029-3-git-send-email-ieidus@redhat.com>
	<1240191366-10029-4-git-send-email-ieidus@redhat.com>
	<1240191366-10029-5-git-send-email-ieidus@redhat.com>
	<1240191366-10029-6-git-send-email-ieidus@redhat.com>
	<20090427153421.2682291f.akpm@linux-foundation.org>
	<49F63BC0.9090804@redhat.com>
	<20090430204624.358c4a2e@woof.tlv.redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Apr 2009 20:46:24 +0300 Izik Eidus <ieidus@redhat.com> wrote:

> Following patchs change the api to be more robust, the result change of
> the api came after conversation i had with Andrea and Chris about how
> to make the api as stable as we can,
> 
> In addition i hope this patchset fix the cross compilation problems, i
> compiled it on itanium (doesnt have _PAGE_RW) and it seems to work.

eek, please don't send multiple patches per email - it's surprisingly
disruptive to everything.

What is the relationship between these patches and the ones I merged
the other day?

