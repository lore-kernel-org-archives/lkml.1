Return-Path: <linux-kernel-owner+w=401wt.eu-S1762114AbXGWVbM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762114AbXGWVbM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 17:31:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753285AbXGWVa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 17:30:57 -0400
Received: from smtp-out.google.com ([216.239.45.13]:31414 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756130AbXGWVa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 17:30:56 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:user-agent:mime-version:to:cc:
	subject:references:in-reply-to:content-type:content-transfer-encoding;
	b=PzmIdR2k5kYWGi2pZAz8CysSavG8SEXFJ8FeBpGuLFWr0z+TRosnAZnwP6AMs3ioO
	zcQzxdK/K+bX6YqnjtMgQ==
Message-ID: <46A51DEB.6090603@google.com>
Date: Mon, 23 Jul 2007 14:30:19 -0700
From: Ethan Solomita <solo@google.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@google.com>
Subject: Re: [PATCH 0/6] cpuset aware writeback
References: <469D3342.3080405@google.com> <20070723131841.02c9b109@schroedinger.engr.sgi.com>
In-Reply-To: <20070723131841.02c9b109@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Tue, 17 Jul 2007 14:23:14 -0700
> Ethan Solomita <solo@google.com> wrote:
> 
>> These patches are mostly unchanged from Chris Lameter's original
>> changelist posted previously to linux-mm.
> 
> Thanks for keeping these patches up to date. Add you signoff if you
> did modifications to a patch. Also include the description of the tests
> in the introduction to the patchset.

	So switch from an Ack to a signed-off? OK, and I'll add descriptions of
testing. Everyone other than you has been silent on these patches. Does
silence equal consent?
	-- Ethan


