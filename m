Return-Path: <linux-kernel-owner+w=401wt.eu-S1755848AbXKJWgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848AbXKJWgw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 17:36:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754877AbXKJWgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 17:36:44 -0500
Received: from mx.treblig.org ([80.68.94.177]:2476 "EHLO mx.treblig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754889AbXKJWgn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 17:36:43 -0500
Date: Sat, 10 Nov 2007 22:04:55 +0000
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: Crispin Cowan <crispin@crispincowan.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       LSM ML <linux-security-module@vger.kernel.org>,
       apparmor-dev <apparmor-dev@forge.novell.com>
Subject: Re: AppArmor Security Goal
Message-ID: <20071110220455.GB24195@gallifrey>
References: <473380AD.5070801@crispincowan.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <473380AD.5070801@crispincowan.com>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/2.6.20.3-bytemark-uml-2 (i686)
X-Uptime: 22:00:14 up 16 days, 12:30,  2 users,  load average: 0.68, 0.58, 0.57
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Crispin Cowan (crispin@crispincowan.com) wrote:

<snip>

>     * Manipulating AppArmor policy requires being both root privileged
>       and not being confined by AppArmor, thus there is explicitly no
>       capability for non-privileged users to change AppArmor policy.

It's a pity that there is no way to do this; it would be nice to restrict
web browsers, document editors etc but allow them
to access the places you commonly store documents etc.

Similarly I'd like to be able to split applications so that
the 'preferences' editing facilities are done by separate
envrionments so that there is no way that a fault in parsing
external data could edit the config (e.g. change home page or
proxy in a browser or default document in an editor).

Dave
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    | Running GNU/Linux on Alpha,68K| Happy  \ 
\ gro.gilbert @ treblig.org | MIPS,x86,ARM,SPARC,PPC & HPPA | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
