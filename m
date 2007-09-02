Return-Path: <linux-kernel-owner+w=401wt.eu-S933897AbXIBCHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933897AbXIBCHS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 22:07:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757816AbXIBCHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 22:07:06 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55963 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466AbXIBCHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 22:07:04 -0400
Date: Sun, 2 Sep 2007 03:06:57 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Casey Dahlin <cjdahlin@ncsu.edu>
Cc: "Constantine A. Murenin" <mureninc@gmail.com>,
       Jeff Garzik <jeff@garzik.org>, Jason Dixon <jason@dixongroup.net>,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk
Subject: Re: That whole "Linux stealing our code" thing
Message-ID: <20070902020657.GP21089@ftp.linux.org.uk>
References: <200709010140.l811eq9H005896@cvs.openbsd.org> <f34ca13c0709010948v67b04b58lb098713dc38c4d6a@mail.gmail.com> <46D99FB7.6030505@garzik.org> <f34ca13c0709011037p221cb40fjf69651d1858df212@mail.gmail.com> <20070901205457.GK9260@stusta.de> <20070901215225.GM9260@stusta.de> <3A831845-B630-42AD-B52F-DC9EA2060BAE@dixongroup.net> <46DA1315.9060002@garzik.org> <f34ca13c0709011839yb32f419s20c259cbaabdd132@mail.gmail.com> <46DA18C2.1000104@ncsu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46DA18C2.1000104@ncsu.edu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 01, 2007 at 09:58:26PM -0400, Casey Dahlin wrote:
> Suppose you saw some other variant of *nix that had some code you wanted 
> to use, but there was a gaping security hole in it. Wouldn't you patch 
> it before you incorporated it? and would it be your fault if this fix 
> made the code not work with the original?
> 
> We took the code and fixed a gaping security vulnerability that appeared 
> within the opening comment. We DO care who does what with our code, and 
> we fully intend to cover our balls.

Who's "we" and would you mind showing your contributions to the tree?
git doesn't seem to find them in 2.5.0-to-current for some reason...
