Return-Path: <linux-kernel-owner+w=401wt.eu-S1754426AbYJAMco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426AbYJAMco (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 08:32:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753904AbYJAMcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 08:32:07 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:25281 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754141AbYJAMcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 08:32:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=iNd8PireLTdQUBTW7IyZC1zOqgsVYpYLUj63zSf8pAnbO9a0pYobG4xQ/7FjTx4whV
         SWxbm1YYev+Bnd5EWbFFACPgR3IlLVfyQgpKG2co8TlSupDSJeDQl3GWkoog6rkaz8Hl
         kVScjWFsC9DuTrxtFjVuy5pjSUzS1TrgZavHc=
Message-ID: <c62985530810010532p4ccd7124l601b575fa1e3778d@mail.gmail.com>
Date: Wed, 1 Oct 2008 14:32:03 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 0/2] ring_buffer: updates for linux-tip
Cc: "Steven Rostedt" <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Peter Zijlstra" <peterz@infradead.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Mathieu Desnoyers" <compudj@krystal.dyndns.org>,
       "Pekka Paalanen" <pq@iki.fi>, "Martin Bligh" <mbligh@google.com>
In-Reply-To: <20081001072300.GD9366@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081001042951.412019606@goodmis.org>
	 <c62985530810010020u1f3f44e1l6b8fb2f31c35d215@mail.gmail.com>
	 <20081001072300.GD9366@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/1 Ingo Molnar <mingo@elte.hu>:
> are the tracer problems you've reported yesterday fixed in latest
> tip/master?

I will not have time to check until this evening. So I will report any potential
feedback tomorrow.
