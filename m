Return-Path: <linux-kernel-owner+w=401wt.eu-S938267AbXFHJb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938267AbXFHJb2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 05:31:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937147AbXFHJbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 05:31:21 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:1506 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937049AbXFHJbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 05:31:19 -0400
Message-ID: <466921F0.9020609@shadowen.org>
Date: Fri, 08 Jun 2007 10:31:28 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Rene Herman <rene.herman@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.03
References: <0a25fd03117c678f17006c5fcefaaed0@pinky> <20070604114110.0b88fe7a.akpm@linux-foundation.org> <4664632C.3050502@shadowen.org> <46646317.2080206@gmail.com>
In-Reply-To: <46646317.2080206@gmail.com>
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=http://www.shadowen.org/~apw/public-key
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote:
> On 06/04/2007 09:08 PM, Andy Whitcroft wrote:
> 
>> I guess line length and white space checks make sense some degree on
>> those files.  I'll sort that out and I guess we'll have anohter version.
> 
> Could you then also post the thing itself, and not just a patch against
> the previous version for us chickens too scared to run -mm?

Ok, the latest version 0.04 is released and I have also put up the
complete script at:

  http://www.shadowen.org/~apw/public/checkpatch/checkpatch.pl-0.04

Previous versions are also there.

-apw
