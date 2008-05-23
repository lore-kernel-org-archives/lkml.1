Return-Path: <linux-kernel-owner+w=401wt.eu-S1757280AbYEWPje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757280AbYEWPje (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 11:39:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754500AbYEWPj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 11:39:27 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:33530 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340AbYEWPj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 11:39:26 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4836E516.1090103@s5r6.in-berlin.de>
Date: Fri, 23 May 2008 17:39:02 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080419 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] raw1394: Push the BKL down into the driver ioctls
References: <20080522223351.22e09d20@core> <48369B0D.7050309@s5r6.in-berlin.de> <20080523115741.5d695706@core>
In-Reply-To: <20080523115741.5d695706@core>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Alan Cox wrote:
>>> Actually in this case wrap the function for now.

I committed it to linux1394-2.6.git#for-next and will send it to Linus 
the next time I have something to pull for him.  I expect that to be 
shortly after 2.6.26 was released.  Is this early enough for your 
file-ops .ioctl removal plan?
-- 
Stefan Richter
-=====-==--- -=-= =-===
http://arcgraph.de/sr/
