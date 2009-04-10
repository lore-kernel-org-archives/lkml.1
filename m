Return-Path: <linux-kernel-owner+w=401wt.eu-S1760084AbZDJSJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760084AbZDJSJb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 14:09:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765860AbZDJSJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 14:09:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45269 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765652AbZDJSJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 14:09:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: suspend-to-ram broken on X61 thinkpads in 2.6.30-rc1?
Date: Fri, 10 Apr 2009 20:08:59 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc1-rjw; KDE/4.2.2; x86_64; ; )
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org
References: <E1Ls9pZ-0004IF-FZ@closure.thunk.org> <20090410175723.GA20983@elf.ucw.cz>
In-Reply-To: <20090410175723.GA20983@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904102008.59932.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 10 April 2009, Pavel Machek wrote:
> On Fri 2009-04-10 02:03:13, Theodore Ts'o wrote:
> > Hi, has anyone else noticed that suspend-to-ram seems to have gotten
> > broken in 2.6.30-rc1, sometime during last half of the merge window?
> > I've been at a conference all of this past week, so I haven't had time
> > to bisect it yet.  I was wondering if anyone else had noticed and
> > figured out what was going wrong.  Symptoms are that the suspend "moon"
> > starts flashing and the system never manages to put itself to sleep.  
> 
> s2ram seems to work ok for me on thinkpad x60... Maybe it is
> hw-dependend, mut maybe it is just a kernel config...

Can you attach yours, so that we could compare, please?

Rafael
