Return-Path: <linux-kernel-owner+w=401wt.eu-S1759569AbYCGXMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759569AbYCGXMt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 18:12:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752207AbYCGXMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 18:12:38 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:53061 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751933AbYCGXMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 18:12:38 -0500
Date: Fri, 7 Mar 2008 15:12:22 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: Deepak Saxena <dsaxena@plexity.net>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [stable] [PATCH-stable] Make 2.6.24.y headers_install work
	again
Message-ID: <20080307231222.GA4416@sequoia.sous-sol.org>
References: <20080307220352.GA10387@plexity.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080307220352.GA10387@plexity.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Deepak Saxena (dsaxena@plexity.net) wrote:
> 
> This reverts commit 5fb7ba76544d95bfa05199f7394a442de5660be7.

Thanks, it's queued up already.

http://git.kernel.org/?p=linux/kernel/git/stable/stable-queue.git;a=blob_plain;f=queue-2.6.24/revert-net-add-if_addrlabel.h-to-sanitized-headers.patch;h=2b713e6ef3731300a5b62c91ac7bd78993d41bcc

-chris
