Return-Path: <linux-kernel-owner+w=401wt.eu-S1753179AbXC1F4H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179AbXC1F4H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 01:56:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753113AbXC1F4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 01:56:06 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:55757 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179AbXC1F4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 01:56:04 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Michael Ellerman <michael@ellerman.id.au>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, Greg Kroah-Hartman <greg@kroah.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       <daniel.e.wolstenholme@intel.com>
Subject: Re: [PATCH 11/21] MSI: Consolidate precondition checks
References: <20070322105341.46C4BDDF39@ozlabs.org>
Date: Tue, 27 Mar 2007 23:55:31 -0600
In-Reply-To: <20070322105341.46C4BDDF39@ozlabs.org> (Michael Ellerman's
	message of "Thu, 22 Mar 2007 21:51:39 +1100")
Message-ID: <m1bqidsyi4.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Ellerman <michael@ellerman.id.au> writes:

> Consolidate precondition checks into a single if statement.

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
