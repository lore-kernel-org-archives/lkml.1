Return-Path: <linux-kernel-owner+w=401wt.eu-S1755818AbYAWTL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818AbYAWTL3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 14:11:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753477AbYAWTLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 14:11:21 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45640 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753343AbYAWTLU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 14:11:20 -0500
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Dave Hansen <haveblue@us.ibm.com>, mbligh@google.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Userspace tracing memory mappings
References: <20080123160454.GA15405@Krystal>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Wed, 23 Jan 2008 14:01:20 -0500
In-Reply-To: <20080123160454.GA15405@Krystal> (Mathieu Desnoyers's message of "Wed, 23 Jan 2008 11:04:54 -0500")
Message-ID: <y0m3aso9xj3.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> writes:

> [...]  Since memory management is not my speciality, I would like to
> know if there are some implementation details I should be aware of
> for my LTTng userspace tracing buffers. Here is what I want to do
> [...]

Would you mind offering some justification for requiring a kernel
extension for user-space tracing?  What can the kernel enable in this
context that a user-space library (which you already assume will be
linked in) can't?

- FChE
