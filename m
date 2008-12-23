Return-Path: <linux-kernel-owner+w=401wt.eu-S1751966AbYLWQES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966AbYLWQES (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 11:04:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751022AbYLWQEB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 11:04:01 -0500
Received: from sandeen.net ([209.173.210.139]:16333 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955AbYLWQEA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 11:04:00 -0500
Message-ID: <49510BEF.2090209@sandeen.net>
Date: Tue, 23 Dec 2008 10:03:59 -0600
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.18 (Macintosh/20081105)
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: Christoph Hellwig <hch@infradead.org>, linux-raid@vger.kernel.org,
       xfs@oss.sgi.com, bug-parted@gnu.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.27.10: cannot mount xfs filesystem partition (12TiB) after
 reboot
References: <alpine.DEB.1.10.0812230829420.4817@p34.internal.lan>	<20081223134247.GA17750@infradead.org>	<alpine.DEB.1.10.0812230950120.7572@p34.internal.lan>	<20081223145431.GA31057@infradead.org> <alpine.DEB.1.10.0812231043540.9812@p34.internal.lan>
In-Reply-To: <alpine.DEB.1.10.0812231043540.9812@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz wrote:


> Better question as well, need to find out if KNOPPIX or distro-CDs support 
> this option, if one to boot into recovery and this option was not 
> enabled.. that would not be fun.

I'd think most do... Fedora does, at least.

-Eric
