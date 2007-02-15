Return-Path: <linux-kernel-owner+w=401wt.eu-S964951AbXBOHMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964951AbXBOHMz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 02:12:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964952AbXBOHMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 02:12:55 -0500
Received: from smtp.osdl.org ([65.172.181.24]:37494 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964951AbXBOHMz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 02:12:55 -0500
Date: Wed, 14 Feb 2007 23:12:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Ingo Molnar <mingo@redhat.com>, systemtap@sources.redhat.com,
       ltt-dev@shafik.org
Subject: Re: [PATCH 00/05] Linux Kernel Markers - kernel 2.6.20
Message-Id: <20070214231201.20918c6b.akpm@linux-foundation.org>
In-Reply-To: <1171224207118-git-send-email-mathieu.desnoyers@polymtl.ca>
References: <1171224207118-git-send-email-mathieu.desnoyers@polymtl.ca>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Feb 2007 15:03:22 -0500 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> You will find, in the following posts, the latest revision of the Linux Kernel
> Markers.

<looks for the documentation>

And what can I do with these markers?

And once I've done it, are there any userspace applications I can use to
get the data out in human-usable form?

It seems to me that these patches aren't sequenced correctly - the kernel won't
build at each step of the patch sequence.  Maybe I'm mistaken in that.  We prefer
it this way so that people don't hit wont-compile points when doing bisection searches.
