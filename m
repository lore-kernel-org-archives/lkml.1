Return-Path: <linux-kernel-owner+w=401wt.eu-S1756636AbXKMPTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636AbXKMPTv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 10:19:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754037AbXKMPTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 10:19:44 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38985 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754044AbXKMPTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 10:19:43 -0500
To: "David J. Wilder" <dwilder@us.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] Add markers into semaphore primitives
References: <1194915156.913.4.camel@lc4eb748232119.ibm.com>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Tue, 13 Nov 2007 10:17:30 -0500
In-Reply-To: <1194915156.913.4.camel@lc4eb748232119.ibm.com> (David J. Wilder's message of "Mon, 12 Nov 2007 16:52:36 -0800")
Message-ID: <y0m4pfq5g51.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


"David J. Wilder" <dwilder@us.ibm.com> writes:

> This patch adds several markers around semaphore primitives.  Along
> with a tracing application this patch can be useful for measuring
> kernel semaphore usage and contention.  [...]

In order to evaluate the permanent placement of markers, more
information will be needed, such as effects upon performance
and code size.

- FChE
