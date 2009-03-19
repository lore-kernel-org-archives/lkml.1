Return-Path: <linux-kernel-owner+w=401wt.eu-S1760308AbZCSUdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760308AbZCSUdt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 16:33:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756249AbZCSUdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 16:33:39 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:56375 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757242AbZCSUdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 16:33:39 -0400
Message-ID: <49C2ACA8.4070503@oracle.com>
Date: Thu, 19 Mar 2009 13:35:52 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: monstr@monstr.eu
CC: linux-kernel@vger.kernel.org, john.williams@petalogix.com
Subject: Re: Microblaze linux support
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu>
In-Reply-To: <1237408284-8674-1-git-send-email-monstr@monstr.eu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt707.oracle.com [141.146.40.85]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.49C2AC1C.0088:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

monstr@monstr.eu wrote:
> Hi all,
> 
> I think that is the right time to send you next pack with 
> Microblaze support. It is seventh pack - some previous packs
> was review by community and I hope there are not any big faults.
> 
> We tested this kernel on some boards.
> We have GIT server up and gitweb is available at http://developer.petalogix.com/git/gitweb.cgi
> 
> All information about git clone you can find on gitweb.
> This pack is available in for-linus branch. Information about other branches are on gitweb too.
> 
> More information about microblaze fdt kernel you can find at www.monstr.eu/fdt/
> If you want to test kernel with microblaze toolchain let me know.

Hi Michal,

Is there an x86-hosted cross-tool chain available?
If so, where?

> I added only uart16550 and uartlite support - that's enought for first merge.
> 
> 
> Thanks for you comments and especially for your ACK,

Thanks,
-- 
~Randy
