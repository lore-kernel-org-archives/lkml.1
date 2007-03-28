Return-Path: <linux-kernel-owner+w=401wt.eu-S1753553AbXC1E3K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553AbXC1E3K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 00:29:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753564AbXC1E3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 00:29:10 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:35591 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553AbXC1E3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 00:29:08 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Michael Ellerman <michael@ellerman.id.au>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, Greg Kroah-Hartman <greg@kroah.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       <daniel.e.wolstenholme@intel.com>
Subject: Re: [PATCH 7/21] Move EXPORT_SYMBOL()s near their definition
References: <20070322105337.B48D5DDF63@ozlabs.org>
Date: Tue, 27 Mar 2007 22:28:40 -0600
In-Reply-To: <20070322105337.B48D5DDF63@ozlabs.org> (Michael Ellerman's
	message of "Thu, 22 Mar 2007 21:51:34 +1100")
Message-ID: <m14po6t2iv.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Ellerman <michael@ellerman.id.au> writes:

> Move EXPORT_SYMBOL()s near their definition.

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
