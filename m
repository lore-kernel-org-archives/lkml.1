Return-Path: <linux-kernel-owner+w=401wt.eu-S1754901AbXJYTFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901AbXJYTFW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 15:05:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752718AbXJYTFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 15:05:08 -0400
Received: from gate.crashing.org ([63.228.1.57]:49851 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752810AbXJYTFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 15:05:07 -0400
In-Reply-To: <1193337589.7705.42.camel@heimdal.trondhjem.org>
References: <CBDE987B-0713-4D62-8122-054183E75410@kernel.crashing.org> <1193188894.27073.20.camel@heimdal.trondhjem.org> <1954B8FA-6E29-4FB7-86B0-EA43AF8F2AAF@kernel.crashing.org> <2B2C1270-60FB-4830-A62C-D0357D2E1FB3@kernel.crashing.org> <1193335168.7705.39.camel@heimdal.trondhjem.org> <6B3D0315-3441-45A1-A007-A193321B654A@kernel.crashing.org> <1193337589.7705.42.camel@heimdal.trondhjem.org>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <7E4866FF-74EE-410E-A5C4-334C7D5461DE@kernel.crashing.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       nfs@lists.sourceforge.net, neilb@suse.de, bfields@fieldses.org,
       chuck.lever@oracle.com
Content-Transfer-Encoding: 7bit
From: Kumar Gala <galak@kernel.crashing.org>
Subject: Re: LTP ustat01 test fails on NFSROOT
Date: Thu, 25 Oct 2007 14:05:05 -0500
To: Trond Myklebust <Trond.Myklebust@netapp.com>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 25, 2007, at 1:39 PM, Trond Myklebust wrote:

>
> On Thu, 2007-10-25 at 13:36 -0500, Kumar Gala wrote:
>> On Oct 25, 2007, at 12:59 PM, Trond Myklebust wrote:
>>
>>> Could you please try the following patch?
>>
>> this fixes my issue.  Any reason this hasn't been accepted?
>
> Do you mean apart from the fact that I wrote it a couple of hours
> ago? :-)

Oh, sorry.  I glanced at the commit message and the 2.6.18 made me  
think its been around for a while.

- k
