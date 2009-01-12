Return-Path: <linux-kernel-owner+w=401wt.eu-S1754112AbZALPpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112AbZALPpZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 10:45:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752576AbZALPpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 10:45:12 -0500
Received: from mx2.redhat.com ([66.187.237.31]:58244 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752569AbZALPpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 10:45:10 -0500
Date: Mon, 12 Jan 2009 10:44:56 -0500
From: Dave Jones <davej@redhat.com>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux killed Kenny, bastard!
Message-ID: <20090112154456.GA27269@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Evgeniy Polyakov <zbr@ioremap.net>, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <20090112153304.GA19995@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090112153304.GA19995@ioremap.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 06:33:05PM +0300, Evgeniy Polyakov wrote:
 > Hi.
 > 
 > Do you want to own a tame killer? Do you want to control the world?
 > 
 > Start with your computer now and own the planet next: you already have
 > an OOM-killer in the Linux to kill for you. But to date it was quite
 > berserk and usually killed not what you would like him to murder.
 > 
 > Now you can add a name of the victims, which will be checked by the
 > oom-killer, who select the process to kill first among the ones which
 > have given string in their executable name.
 > 
 > By default the process to be killed is called 'Kenny', and if you like
 > him, change then name by calling

I realise it ruins the joke, and it sounds unlikely, but anyone who
happens to have a process called 'Kenny' might be unpleasantly surprised
by this.

If we merge this feature, I think it should default to just using the
existing heuristic.

	Dave

-- 
http://www.codemonkey.org.uk
