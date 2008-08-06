Return-Path: <linux-kernel-owner+w=401wt.eu-S1761766AbYHFA5B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761766AbYHFA5B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 20:57:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753697AbYHFAz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 20:55:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47298 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752520AbYHFAz5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 20:55:57 -0400
Date: Tue, 5 Aug 2008 20:51:29 -0400
From: Rik van Riel <riel@redhat.com>
To: "Press, Jonathan" <Jonathan.Press@ca.com>
Cc: "Greg KH" <greg@kroah.com>, "Arjan van de Ven" <arjan@infradead.org>,
       "Eric Paris" <eparis@redhat.com>, <linux-kernel@vger.kernel.org>,
       <malware-list@lists.printk.net>,
       <linux-security-module@vger.kernel.org>
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linuxinterfaceforon
 access scanning
Message-ID: <20080805205129.37d873f0@bree.surriel.com>
In-Reply-To: <2629CC4E1D22A64593B02C43E85553030480743F@USILMS12.ca.com>
References: <20080805103840.1aaa64a5@infradead.org>
	<2629CC4E1D22A64593B02C43E85553030480743B@USILMS12.ca.com>
	<20080805181141.GA10700@kroah.com>
	<2629CC4E1D22A64593B02C43E85553030480743F@USILMS12.ca.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Aug 2008 14:38:23 -0400
"Press, Jonathan" <Jonathan.Press@ca.com> wrote:

> However, I will say that while preventing infections from arriving is
> not foolproof, doing a scan-on-close with the option to delete or
> quarantine an infected file goes a long way.

How can you, as a security professional, argue for a security measure
that you know is flawed, when there is a mailing list full of people
willing to help figure out what a working security measure would look
like?

Yes, abandoning some of the old DOS anti-virus security model may
cause work, but surely that will be worth it if it leads to a more
secure system?

-- 
All rights reversed.
