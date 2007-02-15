Return-Path: <linux-kernel-owner+w=401wt.eu-S1751624AbXBOP3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624AbXBOP3p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 10:29:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751629AbXBOP3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 10:29:44 -0500
Received: from mx1.redhat.com ([66.187.233.31]:40112 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751616AbXBOP3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 10:29:44 -0500
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Ingo Molnar <mingo@redhat.com>, systemtap@sources.redhat.com,
       ltt-dev@shafik.org
Subject: Re: [PATCH 00/05] Linux Kernel Markers - kernel 2.6.20
References: <1171224207118-git-send-email-mathieu.desnoyers@polymtl.ca>
	<20070214231201.20918c6b.akpm@linux-foundation.org>
From: fche@redhat.com (Frank Ch. Eigler)
Date: 15 Feb 2007 10:28:57 -0500
In-Reply-To: <20070214231201.20918c6b.akpm@linux-foundation.org>
Message-ID: <y0mvei330ee.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.0808 (Gnus v5.8.8) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


akpm wrote:

> [...]  And what can I do with these markers?  And once I've done it,
> are there any userspace applications I can use to get the data out
> in human-usable form?  [...]

The LTTng user-space programs use it today.  Systemtap used to support
the earlier marker prototype and will be rapidly ported over to this
new API upon acceptance.

- FChE
