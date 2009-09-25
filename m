Return-Path: <linux-kernel-owner+w=401wt.eu-S1753119AbZIYPvH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119AbZIYPvH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 11:51:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753109AbZIYPvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 11:51:07 -0400
Received: from xenotime.net ([72.52.64.118]:52656 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753104AbZIYPvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 11:51:06 -0400
Message-ID: <4ABCE72D.5040001@xenotime.net>
Date: Fri, 25 Sep 2009 08:52:13 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Jeff Chua <jeff.chua.linux@gmail.com>, Alan Cox <alan@linux.intel.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: linux-2.6.31 INIT: open(/dev/console): Input/output error (due
 to  commit b50989dc444599c8b21edc23536fc305f4e9b7d5)
References: <b6a2187b0909240624u2821a312ub6d02df21d552248@mail.gmail.com>	<20090924160136.44e31ad0@lxorguk.ukuu.org.uk>	<b6a2187b0909240923t4e8d61f4g6d82b7f9f9bf621b@mail.gmail.com>	<20090925115636.5b4b8aca@linux.intel.com>	<b6a2187b0909250835g1b72037er13b86bf762fd5e37@mail.gmail.com> <20090925164747.55dab000@lxorguk.ukuu.org.uk>
In-Reply-To: <20090925164747.55dab000@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> Is this going into Linus's branch soon? Otherwise, please kindly post
>> the full patch so that I can test it instead of pulling 400MB from
>> Andrew's tree.
> 
> I don't have Andrews tty patches here either sorry but I thought he kept
> them broken out on kernel.org ?
> --

http://userweb.kernel.org/~akpm/mmotm/
see the broken-out/ subdir.

~Randy

