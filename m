Return-Path: <linux-kernel-owner+w=401wt.eu-S1751475AbZH2NEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751475AbZH2NEi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 09:04:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751183AbZH2NEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 09:04:37 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39286 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751199AbZH2NEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 09:04:37 -0400
Date: Sat, 29 Aug 2009 14:05:53 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: joe Shmoe <jsmoe3@yahoo.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: kernel page table mapping for >1GB <3 GB for x86 arch without
 PAE
Message-ID: <20090829140553.5cb49cb6@lxorguk.ukuu.org.uk>
In-Reply-To: <47584.30338.qm@web45202.mail.sp1.yahoo.com>
References: <20090828231603.7918be05@lxorguk.ukuu.org.uk>
	<47584.30338.qm@web45202.mail.sp1.yahoo.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Aug 2009 17:20:31 -0700 (PDT)
joe Shmoe <jsmoe3@yahoo.com> wrote:

> Thanks for the reply Alan,
> What I am looking for is this: Let us keep aside the virtual addresses for a process aside for a second. My question does not relate to that at all.

When you understand why that first statement is wrong you will understand
the answer.

Alan
