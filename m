Return-Path: <linux-kernel-owner+w=401wt.eu-S1756683AbXFUQdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683AbXFUQdZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 12:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754296AbXFUQdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 12:33:16 -0400
Received: from terminus.zytor.com ([192.83.249.54]:45002 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857AbXFUQdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 12:33:15 -0400
Message-ID: <467AA76F.9090107@zytor.com>
Date: Thu, 21 Jun 2007 09:29:35 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Ram Pai <linuxram@us.ibm.com>
CC: Al Viro <viro@ftp.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, util-linux-ng@vger.kernel.org
Subject: Re: Adding subroot information to /proc/mounts, or obtaining that
 through other means
References: <467994BD.6000403@zytor.com>	 <20070620210343.GQ21478@ftp.linux.org.uk>  <46799A31.10301@zytor.com> <1182442837.3342.13.camel@ram.us.ibm.com>
In-Reply-To: <1182442837.3342.13.camel@ram.us.ibm.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ram Pai wrote:
> 
> Peter, I am not working on it currently. But i am interested in getting
> it done. I have the seed set of patches which had Al Viro's ideas
> incorporated. Infact those patches were sent on lkml 2 months back.
> Shall we start with those patches?
> 

Are these the "unprivileged mount syscall" patches?

Otherwise I don't see any patches in my personal LKML cache (apparently
my subscription to fsdevel was dropped at some point, so I don't have a
stash of it.)

	-hpa
