Return-Path: <linux-kernel-owner+w=401wt.eu-S1946379AbXD3QgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946379AbXD3QgQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 12:36:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946378AbXD3QgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 12:36:13 -0400
Received: from mx.pathscale.com ([198.186.3.68]:58769 "EHLO mx.pathscale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946490AbXD3QfZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 12:35:25 -0400
Message-ID: <463615D5.1050508@pathscale.com>
Date: Mon, 30 Apr 2007 09:14:13 -0700
From: "Bryan O'Sullivan" <bos@pathscale.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
Cc: Jan Beulich <jbeulich@novell.com>, Roland Dreier <rolandd@cisco.com>,
       linux-kernel@vger.kernel.org, patches@x86-64.org
Subject: Re: [patches] [PATCH] [8/35] x86_64: a memcpy that tries to reducecache
 pressure
References: <20070428752.712152000@suse.de> <20070428175232.5A688151CA@wotan.suse.de> <4635B62D.76E4.0078.0@novell.com> <200704301104.26478.ak@suse.de>
In-Reply-To: <200704301104.26478.ak@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:

> Yes I remember, somehow it got lost. I agree it's a bad thing. Will drop
> the patch for now especially since nothing seems to really need it right now.

It would be used by the ipath driver if it was around.

	<b
