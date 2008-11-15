Return-Path: <linux-kernel-owner+w=401wt.eu-S1755508AbYKOA6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508AbYKOA6S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 19:58:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751854AbYKOA6A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 19:58:00 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39380 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751712AbYKOA6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 19:58:00 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH 0/1] Updated patch (was: Re: [PATCH -next] Hibernate: Take overlapping zones into account)
Date: Sat, 15 Nov 2008 02:01:33 +0100
User-Agent: KMail/1.9.9
Cc: Pavel Machek <pavel@suse.cz>, Dave Hansen <dave@linux.vnet.ibm.com>,
       Andy Whitcroft <apw@shadowen.org>, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Nigel Cunningham <ncunningham@crca.org.au>
References: <200811081356.13060.rjw@sisk.pl> <alpine.LFD.2.00.0811111300580.4480@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0811111300580.4480@localhost.localdomain>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200811150201.34629.rjw@sisk.pl>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Len,

Please replace the "Hibernate: Take overlapping zones into account" patch
(commit 7bff0a928535512dc61cfc81c8ce5dd2a0e53f19 in the suspend branch) with
the new version in the following message.

The old version introduces a tiny memory leak in create_mem_extents().

Thanks,
Rafael

