Return-Path: <linux-kernel-owner+w=401wt.eu-S1763409AbYBFNdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763409AbYBFNdk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 08:33:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761925AbYBFNdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 08:33:33 -0500
Received: from mx2.compro.net ([216.54.166.4]:13392 "EHLO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760931AbYBFNdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 08:33:32 -0500
X-Greylist: delayed 588 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Feb 2008 08:33:32 EST
X-IronPort-AV: E=Sophos;i="4.25,312,1199682000"; 
   d="scan'208";a="1603168"
Message-ID: <47A9B4C4.7010809@compro.net>
Date: Wed, 06 Feb 2008 08:23:16 -0500
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
Organization: Compro Computer Svcs.
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Chris Holvenstot <cholvenstot@comcast.net>
CC: Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.24-git15 Keyboard Issue?
References: <1202302978.9058.13.camel@popeye>
In-Reply-To: <1202302978.9058.13.camel@popeye>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Holvenstot wrote:
> I built 2.6.24-git15 this morning and seem to have picked up a little
> “funny” along the way – occasionally what should be a single key stroke
> ends up spraying multiple characters on to my screen.
> 
> 
> By this I mean I type “w” and get “wwwwwwwww” or whatever. 
> 
> 
> This has happened a number of times with random keys so I don't think
> that it is a sticky key and I did not see this on previous builds.
> 
> 
> Has anyone else had this happen to them?  While they were sober that
> is.    
> 

This or similar has been going on for over a year now. At least on SuSE distros.

See https://bugzilla.novell.com/show_bug.cgi?id=223561

Comment 22 in particular.

Regards
Mark
