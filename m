Return-Path: <linux-kernel-owner+w=401wt.eu-S1752451AbXIYJAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752451AbXIYJAb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 05:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750814AbXIYJAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 05:00:24 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:12610 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbXIYJAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 05:00:23 -0400
Subject: Re: [RFC] New kernel-message logging API
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Joe Perches <joe@perches.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Rob Landley <rob@landley.net>,
       Dick Streefland <dick.streefland@altium.nl>
In-Reply-To: <1190647156.30132.92.camel@localhost>
References: <19f34abd0709221227v67443c0bg2cd2010e5bd5a6c1@mail.gmail.com>
	 <1190625742.12666.30.camel@localhost.localdomain>
	 <1190647156.30132.92.camel@localhost>
Content-Type: text/plain
Organization: IBM
Date: Tue, 25 Sep 2007 10:57:28 +0200
Message-Id: <1190710648.6474.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27.rhel4.6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-09-24 at 08:19 -0700, Joe Perches wrote:
> On Mon, 2007-09-24 at 11:22 +0200, Michael Holzheu wrote:
> > Together with the idea of not allowing multiple lines in the kprint_xxx
> > functions, that would go with our approach having message numbers to
> > identify a message.
> 
> How does this equate/give message numbers?

It does not give us message numbers. It allows us to tag printks, which
have more than one line, with exactly one number.

Michael

