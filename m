Return-Path: <linux-kernel-owner+w=401wt.eu-S1758262AbZIFTb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758262AbZIFTb3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 15:31:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758175AbZIFTb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 15:31:29 -0400
Received: from mail001.aei.ca ([206.123.6.130]:34290 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758130AbZIFTb2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 15:31:28 -0400
From: Ed Tomlinson <edt@aei.ca>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.31.rc9
Date: Sun, 6 Sep 2009 15:31:28 -0400
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc9-crc; KDE/4.2.4; x86_64; ; )
Cc: Gene Heskett <gene.heskett@verizon.net>, linux-kernel@vger.kernel.org
References: <200909061402.21536.gene.heskett@verizon.net> <200909062041.19361.rjw@sisk.pl>
In-Reply-To: <200909062041.19361.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909061531.29147.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 06 September 2009 14:41:19 Rafael J. Wysocki wrote:
> On Sunday 06 September 2009, Gene Heskett wrote:
> > Greetings all;
> > 
> > I went ahead and buiilt 2.6.31-rc9 & rebooted to it, but I am being plagued 
> > by segfaults, taking down knotify and kmail, and a bluetooth tool I just 
> > tried to run.
> > 
> > kmail restarted ok, but several others have reported that the exec call 
> > failed.
> > 
> > No more than I know about slabtop, it looks much like it has before.
> 
> Is that 64-bit or 32-bit?
> 
> I don't see the problems you describe on any of my test boxes.

This is interesting.  I have noticed that it takes two trys to get kmail to start here.  Never thought it
might be kernel related though.  Thinking about it it started happen about the time I flipped from 30
to 31-rc8.  I am gentoo amd64.

Thanks
Ed
