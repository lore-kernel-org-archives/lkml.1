Return-Path: <linux-kernel-owner+w=401wt.eu-S1757438AbYEWRbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438AbYEWRbr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 13:31:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751102AbYEWRbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 13:31:38 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:37340 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750871AbYEWRbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 13:31:37 -0400
Date: Fri, 23 May 2008 13:30:50 -0400
From: Theodore Tso <tytso@MIT.EDU>
To: linux-kernel@vger.kernel.org,
       ksummit-2008-discuss@lists.linux-foundation.org
Subject: Re: 2008 Linux Kernel Summit
Message-ID: <20080523173050.GG5265@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	linux-kernel@vger.kernel.org,
	ksummit-2008-discuss@lists.linux-foundation.org
References: <E1Jzb3a-0008DS-Tu@closure.thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Jzb3a-0008DS-Tu@closure.thunk.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2008 at 01:27:54PM -0400, Theodore Ts'o wrote:
> 
> #!/usr/bin/perl
> $at="@";
> $AD=(gmtime(time))[5]+1900;
> print "ksummit-" . $AD . "-discuss" . $at . "thunk.org\n";
> print "http://lists.linux-foundation.org/mailman/listinfo/ksummit-" . $AD . "-discuss\n";
> 

Oops!  Obviously, that should read:

#!/usr/bin/perl
$at="@";
$AD=(gmtime(time))[5]+1900;
print "ksummit-" . $AD . "-discuss" . $at . "lists.linux-foundation.org\n";
print "http://lists.linux-foundation.org/mailman/listinfo/ksummit-" . $AD . "-discuss\n";

						- Ted
