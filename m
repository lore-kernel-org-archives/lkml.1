Return-Path: <linux-kernel-owner+w=401wt.eu-S1755945AbYANVga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945AbYANVga (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 16:36:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751681AbYANVgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 16:36:21 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45571 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751568AbYANVgV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 16:36:21 -0500
Message-ID: <478BD5B8.1010805@redhat.com>
Date: Mon, 14 Jan 2008 15:35:52 -0600
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: zippel@linux-m68k.org, linux-kernel@vger.kernel.org
Subject: Re: fs/hfs/btree.c: new NULL dereference
References: <20080114211305.GI9847@does.not.exist>
In-Reply-To: <20080114211305.GI9847@does.not.exist>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> The Coverity checker spotted the following NULL dereference introduced 
> by commit cf0594625083111ae522496dc1c256f7476939c2:

Oops.  Thanks, Adrian.

Patch sent on a different thread, following another fixup patch for
Roman - you're cc'd.

Thanks,

-Eric
