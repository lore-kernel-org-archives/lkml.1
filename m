Return-Path: <linux-kernel-owner+w=401wt.eu-S1755395AbYFTBHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395AbYFTBHJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 21:07:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599AbYFTBG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 21:06:57 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:39332 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbYFTBG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 21:06:57 -0400
Message-ID: <26632869.1213923996055.JavaMail.oracle@acsmt302.oracle.com>
Date: Thu, 19 Jun 2008 20:06:36 -0500 (CDT)
From: Randy Dunlap <randy.dunlap@oracle.com>
To: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH] kernel-doc: handle/strip __init
Cc: lkml <linux-kernel@vger.kernel.org>, samr <sam@ravnborg.org>,
       akpm <akpm@linux-foundation.org>
In-Reply-To: <200806191652.42717.david-b@pacbell.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
References: <20080619160329.1a4fe917.randy.dunlap@oracle.com> <200806191652.42717.david-b@pacbell.net>
X-Priority: 3
X-Mailer: Oracle Webmail Client(UIX)
Content-Language: en-US
Accept-Language: en-US
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Original Message ---
> On Thursday 19 June 2008, Randy Dunlap wrote:
> > Handle __init in functions with kernel-doc notation by stripping the
> > __init away from the output doc.  This is already being done for
> > "__devinit".  
> 
> Right.  Shouldn't this also be done for __exit and __devexit
> too?

Yes, but I generally wait until they are needed.

~Randy

