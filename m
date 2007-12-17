Return-Path: <linux-kernel-owner+w=401wt.eu-S1765659AbXLQQfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765659AbXLQQfb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 11:35:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760061AbXLQQfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 11:35:18 -0500
Received: from capone.Concordia.CA ([132.205.7.82]:41144 "EHLO
	capone.concordia.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756242AbXLQQfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 11:35:16 -0500
X-Greylist: delayed 2649 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Dec 2007 11:35:16 EST
Date: Mon, 17 Dec 2007 10:51:02 -0500 (EST)
From: Sylvain Robitaille <syl@alcor.concordia.ca>
To: Tao Wang <taow@alcor.concordia.ca>
cc: Steven Winikoff <smw@alcor.concordia.ca>, <linux-kernel@vger.kernel.org>,
       Sheila Ettinger <sheilae@alcor.concordia.ca>,
       Tan Bui <tan@alcor.concordia.ca>,
       Gillian Roper <groper@alcor.concordia.ca>
Subject: Re: 2.6.23.8: OOM killer kills wrong jobs
In-Reply-To: <1241.65.94.28.163.1197906245.squirrel@webmail.concordia.ca>
Message-ID: <Pine.OSF.4.44.0712171046390.285022-100000@alcor.concordia.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(removing Alan Cox from the Cc: list;  He does not need to be involved
in the details of our discussions of local systems ...)

On Mon, 17 Dec 2007 taow@alcor.concordia.ca wrote:

> ... Thesis 1,2,3 has 16GB memory. Aries has 12G.

Note that the Theses and Aries are Xeon systems, which are 32-bit systems
in the first place, so the problem described is likely not applicable
to these.  I fully expect that the problem being encountered on Baby Alcor
(and Bonnie?) is specifically because of the large memory configuration,
on a 64-bit system, but running a 32-bit OS configuration.  At least
that's how I understood the explanation.

-- 
----------------------------------------------------------------------
Sylvain Robitaille                              syl@alcor.concordia.ca

Systems and Network analyst                       Concordia University
Instructional & Information Technology        Montreal, Quebec, Canada
----------------------------------------------------------------------

