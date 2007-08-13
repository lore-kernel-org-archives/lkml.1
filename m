Return-Path: <linux-kernel-owner+w=401wt.eu-S970814AbXHMRtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970814AbXHMRtx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 13:49:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S974062AbXHMRoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 13:44:01 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:50320 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S971196AbXHMRn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 13:43:59 -0400
Message-ID: <46C0977A.9010308@gmail.com>
Date: Mon, 13 Aug 2007 19:40:10 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
CC: Joe Perches <joe@perches.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] [1/2many] - FInd the maintainer(s) for a patch - scripts/get_maintainer.pl
References: <1186984174.10249.7.camel@localhost> <20070813071606.GF21089@ftp.linux.org.uk>
In-Reply-To: <20070813071606.GF21089@ftp.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2007 09:16 AM, Al Viro wrote:

> On Sun, Aug 12, 2007 at 10:49:34PM -0700, Joe Perches wrote:
>> I grew weary of looking up the appropriate
>> maintainer email address(es) to CC: for a patch.
> 
> Does the acronym GAFL ring any bells?  It's not that idea is worthless -
> it sure as hell is a useful thing, but what the bleeding hell is that
> splitup supposed to achieve?

Well, to be fair, he's CCing the addresses in the individual entries which 
is at least somewhat of a reason. Yes, could've worked via preparation via 
private mail as well or something but hey, posting some 600 patches is at 
least incredibly funny :-)

Only thing left now is to now teach Linus's copy of git about these entries 
so that it doesn't turn into an wholy incomplete, obsolete mess through 
addition, removal and movement of files in a few months time...

Rene.
