Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755632Ab0CHUJI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 15:09:08 -0500
Received: from mail.g-wis.com ([204.250.154.18]:1505 "EHLO mail.g-wis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755533Ab0CHUJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 15:09:04 -0500
X-Greylist: delayed 371 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Mar 2010 15:09:04 EST
X-Envelope-From: lenb@kernel.org
X-Received-From-Address: 63.253.19.82
thread-index: Acq++XswxS2FJtcfS4mR9LhFRPg8Gw==
Content-Transfer-Encoding: 7bit
Content-Class: urn:content-classes:message
Importance: normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4325
Date: Mon, 8 Mar 2010 14:19:53 -0500 (EST)
From: "Len Brown" <lenb@kernel.org>
X-X-Sender: lenb@sony
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "Bjorn Helgaas" <bjorn.helgaas@hp.com>, <linux-acpi@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, "Adam Belay" <abelay@mit.edu>
Subject: Re: [PATCH v2 0/7] resource, PNPACPI: add bus number and window support
In-Reply-To: <alpine.LFD.2.00.1003061145260.31447@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1003081418440.3672@sony>
References: <20100305174656.21946.93874.stgit@bob.kio> <alpine.LFD.2.00.1003061145260.31447@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN;
	charset="US-ASCII"
X-OriginalArrivalTime: 08 Mar 2010 19:56:44.0825 (UTC) FILETIME=[7AB44890:01CABEF9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series looks good to me.
I've added it to the acpi tree to be sure it sees linux-next.
I expect to hear back from Jesse with his ack/nack shortly.

thanks,
Len Brown, Intel Open Source Technology Center

