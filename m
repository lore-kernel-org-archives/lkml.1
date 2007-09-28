Return-Path: <linux-kernel-owner+w=401wt.eu-S1758811AbXI1ORd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758811AbXI1ORd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 10:17:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754045AbXI1ORZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 10:17:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57735 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751583AbXI1ORY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 10:17:24 -0400
Date: Fri, 28 Sep 2007 10:17:11 -0400
From: Rik van Riel <riel@redhat.com>
To: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
Cc: Daniel =?UTF-8?B?U3DDpW5n?= <daniel.spang@gmail.com>,
       <linux-kernel@vger.kernel.org>
Subject: Re: Out of memory management in embedded systems
Message-ID: <20070928101711.504eb198@bree.surriel.com>
In-Reply-To: <Pine.LNX.4.61.0709281000300.9062@chaos.analogic.com>
References: <cfd9edbf0709280555n51afa8aft5040331ae9c227fd@mail.gmail.com>
	<Pine.LNX.4.61.0709280857520.8940@chaos.analogic.com>
	<cfd9edbf0709280630x7396e49fi523e1d58aab9458a@mail.gmail.com>
	<Pine.LNX.4.61.0709281000300.9062@chaos.analogic.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Sep 2007 10:04:23 -0400
"linux-os \(Dick Johnson\)" <linux-os@analogic.com> wrote:
> On Fri, 28 Sep 2007, [iso-8859-1] Daniel Spång wrote:
> 
> > On 9/28/07, linux-os (Dick Johnson) <linux-os@analogic.com> wrote:
> >>
> >> On Fri, 28 Sep 2007, [iso-8859-1] Daniel Spång wrote:

> >>> Some kind of notification to the application that the available memory
> >>> is scarce and let the application free up some memory (e.g., by
> >>> flushing caches), could be used to improve the situation 

> Any networked appliance can (will) throw data away if there are
> no resources available.

That is exactly what Daniel proposed in his first email.

I think his idea makes sense.

-- 
"Debugging is twice as hard as writing the code in the first place.
Therefore, if you write the code as cleverly as possible, you are,
by definition, not smart enough to debug it." - Brian W. Kernighan
