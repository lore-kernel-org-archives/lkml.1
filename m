Return-Path: <linux-kernel-owner+w=401wt.eu-S1765707AbXJORMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765707AbXJORMy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 13:12:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765518AbXJORMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 13:12:41 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:36585 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765297AbXJORMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 13:12:39 -0400
Date: Mon, 15 Oct 2007 12:12:37 -0500
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, gregkh <greg@kroah.com>,
       akpm <akpm@linux-foundation.org>, linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [PATCH] pci: implement "pci=noaer"
Message-ID: <20071015171237.GD4891@austin.ibm.com>
References: <20071005131758.5dd8cf85.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071005131758.5dd8cf85.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.11
From: linas@austin.ibm.com (Linas Vepstas)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, Oct 05, 2007 at 01:17:58PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> For cases in which CONFIG_PCIEAER=y (such as distro kernels), allow users
> to disable PCIE Advanced Error Reporting by using "pci=noaer" on the
> kernel command line.

Looks reasonable to me. 

(sorry for the belated reply... I also saw this in gregkh's patch
series. Since the email was addressed to me, I figure I should 
at least say "yes I read it". Dunno if "Yes-I-read-it-by:" is 
the same as "Acked by:", if it is, then acked-by me.. )

--linas

