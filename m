Return-Path: <linux-kernel-owner+w=401wt.eu-S1761368AbYHFAXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761368AbYHFAXa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 20:23:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751223AbYHFAW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 20:22:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53992 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960AbYHFAW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 20:22:57 -0400
Date: Tue, 5 Aug 2008 20:22:31 -0400
From: Rik van Riel <riel@redhat.com>
To: "Press, Jonathan" <Jonathan.Press@ca.com>
Cc: "Arjan van de Ven" <arjan@infradead.org>, "Eric Paris" <eparis@redhat.com>,
       "Greg KH" <greg@kroah.com>, <linux-kernel@vger.kernel.org>,
       <malware-list@lists.printk.net>,
       <linux-security-module@vger.kernel.org>
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linux
 interfaceforon access scanning
Message-ID: <20080805202231.5e46ccab@bree.surriel.com>
In-Reply-To: <2629CC4E1D22A64593B02C43E85553030480743B@USILMS12.ca.com>
References: <1217883616.27684.19.camel@localhost.localdomain>
	<20080804223249.GA10517@kroah.com>
	<1217896374.27684.53.camel@localhost.localdomain>
	<2629CC4E1D22A64593B02C43E855530304807431@USILMS12.ca.com>
	<1217948212.27684.120.camel@localhost.localdomain>
	<2629CC4E1D22A64593B02C43E855530304807436@USILMS12.ca.com>
	<1217956796.11547.12.camel@paris.rdu.redhat.com>
	<20080805103840.1aaa64a5@infradead.org>
	<2629CC4E1D22A64593B02C43E85553030480743B@USILMS12.ca.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Aug 2008 14:04:26 -0400
"Press, Jonathan" <Jonathan.Press@ca.com> wrote:

> You can say that there are four parts to the malware life cycle --
> getting on a machine, residing there, causing local damage, and
> propagating elsewhere. 

We're getting close.

What exactly are the threat models you want to protect against?

Once we have the answer to that question, we can figure out
whether the current patch set addresses the threat model or
whether alternate approaches are needed.

-- 
All rights reversed.
