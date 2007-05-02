Return-Path: <linux-kernel-owner+w=401wt.eu-S932458AbXEBCpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932458AbXEBCpc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 22:45:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030433AbXEBCpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 22:45:32 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:43707 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932458AbXEBCpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 22:45:31 -0400
Message-Id: <1178073930.23727.1187619425@webmail.messagingengine.com>
X-Sasl-Enc: MWN0mUL8Ud5cQjtgEKKE3VVjJJrLHVh3jdfHboWsVpNU 1178073930
From: lkml777@123mail.org
To: "Andi Kleen" <andi@firstfloor.org>
Cc: "Jeff Chua" <jeff.chua.linux@gmail.com>, linux-kernel@vger.kernel.org,
       "Eric Hopper" <hopper@omnifarious.org>,
       "William Heimbigner" <icxcnika@mar.tar.cc>,
       "Alex Zarochentsev" <zam@namesys.com>,
       "Andi Kleen" <andi@firstfloor.org>, "Rik van Riel" <riel@redhat.com>,
       "Edward Shishkin" <edward@namesys.com>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <462E17AF.7090604@namesys.com>
   <20070424193921.GA17129@one.firstfloor.org>
   <462F6717.70508@namesys.com>
   <b6a2187b0704250749s2a00dadep93b2943bc0b9df9d@mail.gmail.com>
   <1177564182.15467.1186637743@webmail.messagingengine.com>
   <b6a2187b0704252348t1242560dqad6a1d30e665abc5@mail.gmail.com>
   <b6a2187b0704260118x7cf8ed57mab9a12d06a2471a9@mail.gmail.com>
   <1177658163.8094.1186854037@webmail.messagingengine.com>
   <b6a2187b0704270937g18f305cdxfdd54349fb73f3ea@mail.gmail.com>
   <1177717116.1762.1186993177@webmail.messagingengine.com>
   <20070428182928.GA8436@one.firstfloor.org>
Subject: Re: Question about Reiser4 (how to boot it?)
In-Reply-To: <20070428182928.GA8436@one.firstfloor.org>
Date: Tue, 01 May 2007 19:45:30 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 28 Apr 2007 20:29:28 +0200, "Andi Kleen" <andi@firstfloor.org>
said:
> > By any chance did you do that?
> 
> It will likely work with lilo -- it is file system independent as 
> long as the file system implements the IOC_UNPACK ioctl, which
> r4 seems to.
> 
> -Andi

I used a kernel and initrd transfered to an ext3 partition to boot the
reiser4 partition.
-- 
  
  lkml777@123mail.org

-- 
http://www.fastmail.fm - Send your email first class

