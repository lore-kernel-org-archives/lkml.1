Return-Path: <linux-kernel-owner+w=401wt.eu-S933983AbXIBB66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933983AbXIBB66 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 21:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933435AbXIBB6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 21:58:51 -0400
Received: from uni21mr.unity.ncsu.edu ([152.1.2.137]:59563 "EHLO
	uni21mr.unity.ncsu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933112AbXIBB6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 21:58:50 -0400
Message-ID: <46DA18C2.1000104@ncsu.edu>
Date: Sat, 01 Sep 2007 21:58:26 -0400
From: Casey Dahlin <cjdahlin@ncsu.edu>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: "Constantine A. Murenin" <mureninc@gmail.com>
CC: Jeff Garzik <jeff@garzik.org>, Jason Dixon <jason@dixongroup.net>,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk
Subject: Re: That whole "Linux stealing our code" thing
References: <200709010140.l811eq9H005896@cvs.openbsd.org>	 <f34ca13c0709010948v67b04b58lb098713dc38c4d6a@mail.gmail.com>	 <46D99FB7.6030505@garzik.org>	 <f34ca13c0709011037p221cb40fjf69651d1858df212@mail.gmail.com>	 <20070901205457.GK9260@stusta.de> <20070901215225.GM9260@stusta.de>	 <3A831845-B630-42AD-B52F-DC9EA2060BAE@dixongroup.net>	 <46DA1315.9060002@garzik.org> <f34ca13c0709011839yb32f419s20c259cbaabdd132@mail.gmail.com>
In-Reply-To: <f34ca13c0709011839yb32f419s20c259cbaabdd132@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-PMX-Version: 5.3.2.304607, Antispam-Engine: 2.5.0.283055, Antispam-Data: 2007.9.1.181523
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Suppose you saw some other variant of *nix that had some code you wanted 
to use, but there was a gaping security hole in it. Wouldn't you patch 
it before you incorporated it? and would it be your fault if this fix 
made the code not work with the original?

We took the code and fixed a gaping security vulnerability that appeared 
within the opening comment. We DO care who does what with our code, and 
we fully intend to cover our balls.

The problem is yours to fix. If you actually care, use a license that 
SAYS you care. Right now there's a big /* I don't give a shit */ on top 
of every BSD file. We took you at your word and assumed you didn't. Now 
its too late and you suddenly care, don't you?
