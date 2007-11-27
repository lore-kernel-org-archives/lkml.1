Return-Path: <linux-kernel-owner+w=401wt.eu-S1757482AbXK0JW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482AbXK0JW0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 04:22:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752369AbXK0JWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 04:22:19 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:35740 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbXK0JWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 04:22:18 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Containers <containers@lists.osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] utsns: Restore proper namespace handling.
References: <m11wagpxw6.fsf@ebiederm.dsl.xmission.com>
	<20071126151917.GF547@sergelap.austin.ibm.com>
	<20071126225517.0245a86d.akpm@linux-foundation.org>
Date: Tue, 27 Nov 2007 02:20:01 -0700
In-Reply-To: <20071126225517.0245a86d.akpm@linux-foundation.org> (Andrew
	Morton's message of "Mon, 26 Nov 2007 22:55:17 -0800")
Message-ID: <m18x4km4e6.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:


> I already have a (more codingstylely attractive) version of this from
> Pavel, for which I shall steal your ack.

Perfectly fine.  I overlooked that one when I generated this patch
the first time (Oops). Let's just get this bug fixed.

Eric
