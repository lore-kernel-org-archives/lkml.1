Return-Path: <linux-kernel-owner+w=401wt.eu-S1758734AbYHFSGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758734AbYHFSGv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 14:06:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753955AbYHFSFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 14:05:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52594 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753434AbYHFSFO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 14:05:14 -0400
Date: Wed, 6 Aug 2008 14:04:58 -0400
From: Rik van Riel <riel@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Paris <eparis@redhat.com>,
       Greg KH <greg@kroah.com>, malware-list@lists.printk.net,
       linux-kernel@vger.kernel.org
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linux interface for
 on access scanning
Message-ID: <20080806140458.5d7c86a2@cuia.bos.redhat.com>
In-Reply-To: <87zlnq6f27.fsf@basil.nowhere.org>
References: <1217883616.27684.19.camel@localhost.localdomain>
	<20080804223249.GA10517@kroah.com>
	<20080805002618.GA18215@infradead.org>
	<1217897224.27684.66.camel@localhost.localdomain>
	<20080805005415.GA10108@infradead.org>
	<87zlnq6f27.fsf@basil.nowhere.org>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Aug 2008 04:41:04 +0200
Andi Kleen <andi@firstfloor.org> wrote:
> Christoph Hellwig <hch@infradead.org> writes:
> 
> > I couldn't give a rats a** about
> > windows viruses as they can't actually cause any harm on a Linux
> > machine.
> 
> My guess is that wine is good enough these days to run many Windows 
> worms actually.

Firefox, Open Office and other applications are probably large and
feature rich enough that making worms for them might be possible.

Not being able to harm the operating system is not the same as not
being able to harm the user.  We still want some protection from
the latter...

-- 
All Rights Reversed
