Return-Path: <linux-kernel-owner+w=401wt.eu-S934645AbZGQNlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934645AbZGQNlL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 09:41:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934632AbZGQNlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 09:41:10 -0400
Received: from smtp.nokia.com ([192.100.122.233]:35493 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934522AbZGQNlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 09:41:09 -0400
Subject: Re: [PATCH] Clean up some extra unused arguments in fs/ubifs/
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Subrata Modak <subrata@linux.vnet.ibm.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Adrian Hunter <adrian.hunter@nokia.com>,
       Sachin P Sant <sachinp@linux.vnet.ibm.com>,
       David Howells <dhowells@redhat.com>, linux-mtd@lists.infradead.org,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4A607D9D.6090301@gmail.com>
References: <20090717062101.11440.49299.sendpatchset@subratamodak.linux.ibm.com>
	 <1247815718.11353.177.camel@localhost.localdomain>
	 <1247837392.5690.3.camel@subratamodak.linux.ibm.com>
	 <4A607D9D.6090301@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 17 Jul 2009 16:40:11 +0300
Message-Id: <1247838011.11353.184.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 17 Jul 2009 13:40:17.0572 (UTC) FILETIME=[1EFD7E40:01CA06E4]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-17 at 16:33 +0300, Artem Bityutskiy wrote:
> > Ok then, do you want me to
> > send a separate patch for 2) & 3), or, you will automatically isolate
> > them from the sent one.
> 
> I can isolate them myself, thanks for the patch.

Is this OK?
http://git.infradead.org/ubifs-2.6.git?a=commit;h=d71df6df5752abe700d547016baea801ce868844

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

