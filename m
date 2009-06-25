Return-Path: <linux-kernel-owner+w=401wt.eu-S1759509AbZFYIHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759509AbZFYIHA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 04:07:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755726AbZFYIGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 04:06:35 -0400
Received: from smtp-out.google.com ([216.239.33.17]:62996 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755759AbZFYIGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 04:06:31 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=MN6WZ0PYVX6nSF+BKDyKYw1SVxCV3DlkbT2am9n7Kx8xQgex8GyhdOHOJWxm6nnQZ
	7g6aSnhHYSYm9ZYew3rCg==
MIME-Version: 1.0
In-Reply-To: <4A432DD4.3010905@panasas.com>
References: <20090620005524.25582.69677.stgit@menage.mtv.corp.google.com>
	 <4A3F4448.30502@panasas.com>
	 <20090625135901.a028512d.sfr@canb.auug.org.au>
	 <4A432DD4.3010905@panasas.com>
Date: Thu, 25 Jun 2009 01:06:27 -0700
Message-ID: <6599ad830906250106q2807c72ci21e95b02448ec4f7@mail.gmail.com>
Subject: Re: [uml-devel] [PATCH] UML: Fix some apparent bitrot
From: Paul Menage <menage@google.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>, jdike@addtoit.com,
       linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net,
       Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 25, 2009 at 12:57 AM, Boaz Harrosh<bharrosh@panasas.com> wrote:
>
> Paul? we did not receive any feedback from you

I split it out into two patches and sent them about an hour ago. (One
for mmu_context.h sent to Rusty and one for the other two fixes, sent
to Linus)

Paul
