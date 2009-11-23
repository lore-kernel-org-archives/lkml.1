Return-Path: <linux-kernel-owner+w=401wt.eu-S1757583AbZKWXnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757583AbZKWXnW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 18:43:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757416AbZKWXnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 18:43:20 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:21084 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757541AbZKWXnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 18:43:19 -0500
Message-ID: <4B0B1DD2.9000404@oracle.com>
Date: Mon, 23 Nov 2009 15:42:10 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for November 23
References: <20091123185232.1423c56b.sfr@canb.auug.org.au> <20091123111510.9b0c0714.randy.dunlap@oracle.com> <200911240924.54675.rusty@rustcorp.com.au> <20091124103318.bfcb504c.sfr@canb.auug.org.au> <20091123233843.GA13464@suse.de>
In-Reply-To: <20091123233843.GA13464@suse.de>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4B0B1E10.009D:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Tue, Nov 24, 2009 at 10:33:18AM +1100, Stephen Rothwell wrote:
>> Hi Rusty,
>>
>> On Tue, 24 Nov 2009 09:24:54 +1030 Rusty Russell <rusty@rustcorp.com.au> wrote:
>>>     And I guess linux-next doesn't build staging?
>> Correct - it breaks to much and too often :-)
> 
> Yes, remember, it's crap, you don't want to build it :)

that's certainly one way to look at it, but I do spend time/effort
trying to get it to build, then send patches that either get dropped
or sit in a queue or ignored for a long time by their driver writer,
so you are just reinforcing the negativism associated with staging.

I don't think that's what you should be doing.


-- 
~Randy
