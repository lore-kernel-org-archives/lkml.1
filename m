Return-Path: <linux-kernel-owner+w=401wt.eu-S1754081AbYADN5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081AbYADN5v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 08:57:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753578AbYADN40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 08:56:26 -0500
Received: from www.church-of-our-saviour.org ([69.25.196.31]:37133 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753421AbYADN4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 08:56:24 -0500
Date: Fri, 4 Jan 2008 08:56:20 -0500
From: Theodore Tso <tytso@mit.edu>
To: Mathieu SEGAUD <mathieu.segaud@regala.cx>
Cc: akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [Coding Style]: misc fixes for fs/ext{3,4}/acl.{c,h}
	from checkpatch.pl
Message-ID: <20080104135620.GF17436@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Mathieu SEGAUD <mathieu.segaud@regala.cx>,
	akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1199452896-20145-1-git-send-email-mathieu.segaud@regala.cx> <20080104134458.GE17436@mit.edu> <871w8xem5o.fsf@barad-dur.regala.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <871w8xem5o.fsf@barad-dur.regala.cx>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 04, 2008 at 02:49:07PM +0100, Mathieu SEGAUD wrote:
> Vous m'avez dit récemment :
> 
> > Coding-style only changes tends to screw up our ability to merge
> > pending patches, but I'll take care of it, thanks
> 
> yep, I noticed that...
> would you rather me wait till 2.6.24 is out ?

I'll take your patches and merge all or most of it as I can into the
patch queue destined for 2.6.24-rc1.  Check back with me after -rc1;
if there are some left over we'll do them after that.

   	     	       	    	     	  	- Ted

