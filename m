Return-Path: <linux-kernel-owner+w=401wt.eu-S1752886AbYJVGSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886AbYJVGSi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 02:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751471AbYJVGS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 02:18:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48329 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751229AbYJVGS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 02:18:27 -0400
Date: Tue, 21 Oct 2008 23:17:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: sfr@canb.auug.org.au,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: Sending patches, against linux-next.git, linux-2.6.git or what?
Message-Id: <20081021231757.7cf40e23.akpm@linux-foundation.org>
In-Reply-To: <48FEAD30.3090906@lougher.demon.co.uk>
References: <48FEAD30.3090906@lougher.demon.co.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2008 05:33:52 +0100 Phillip Lougher <phillip@lougher.demon.co.uk> wrote:

> Hi,
> 
> I'm about to send another respin of the Squashfs patches.  Do I base 
> them against linux-next.git, linux-2.6.git or what?  I thought they 
> should be against linux-next, but I've already got one complaint.  So, 
> I'm confused, what tree should new patches be based off?
> 

If they're being released for people to test and play with, I'd make
them aginst mainline or 2.6.27.

If they're being released for review-and-merge then yes, linux-next
would be better, but that's a fairly minor merging matter.  A much bigger
task is getting them reviewed and generally getting a bit of
momentum/interest/enthusiasm/etc.

