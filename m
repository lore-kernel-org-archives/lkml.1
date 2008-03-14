Return-Path: <linux-kernel-owner+w=401wt.eu-S1753830AbYCNEBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830AbYCNEBP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 00:01:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750889AbYCNEBD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 00:01:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:43804 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779AbYCNEBC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 00:01:02 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 0/2] PM: Remove legacy PM
Date: Fri, 14 Mar 2008 00:00:02 -0400
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Ralf Baechle <ralf@linux-mips.org>
References: <200803132351.19794.rjw@sisk.pl>
In-Reply-To: <200803132351.19794.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803140000.02420.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 March 2008, Rafael J. Wysocki wrote:
> Hi Len,
> 
> The first of the following two patches removes the legacy PM infrastructure
> and the second one removes some of its remnants from the MIPS tree.
> 
> Please add them to the suspend branch.

done.
and suspend branch is now rebased to latest linus

thanks,
-Len

