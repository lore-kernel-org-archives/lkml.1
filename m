Return-Path: <linux-kernel-owner+w=401wt.eu-S936292AbYGCHOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936292AbYGCHOR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 03:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754997AbYGCG6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 02:58:45 -0400
Received: from smtp1-g19.free.fr ([212.27.42.27]:43120 "EHLO smtp1-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755266AbYGCGXE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 02:23:04 -0400
From: Christian Couder <chriscool@tuxfamily.org>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: Updated Kernel Hacker's guide to git
Date: Thu, 3 Jul 2008 08:26:59 +0200
User-Agent: KMail/1.9.9
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Git Mailing List <git@vger.kernel.org>
References: <200612241807.kBOI746w008739@laptop13.inf.utfsm.cl> <Pine.LNX.4.64.0712310349260.2093@fbirervta.pbzchgretzou.qr> <486849C0.7050703@garzik.org>
In-Reply-To: <486849C0.7050703@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200807030827.00086.chriscool@tuxfamily.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Le lundi 30 juin 2008, Jeff Garzik a écrit :
> Jan Engelhardt wrote:
> > On Dec 23 2007 06:13, Jeff Garzik wrote:
> >> Another year, another update!  :)
> >>
> >> The kernel hacker's guide to git has received some updates:
> >>
> >> 	http://linux.yyz.us/git-howto.html

May I suggest adding some stuff about "git bisect", or at least links to 
other documentation about it, in this guide?

Especially, you may want to add an example about how to automate testing 
using "git bisect run" as you suggest other to do that:

http://www.ussg.iu.edu/hypermail/linux/kernel/0804.1/0633.html

Thanks in advance,
Christian.
