Return-Path: <linux-kernel-owner+w=401wt.eu-S2992933AbXDDQd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992933AbXDDQd0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 12:33:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992989AbXDDQd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 12:33:26 -0400
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:47832 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992933AbXDDQdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 12:33:25 -0400
Message-ID: <4613D342.3040501@s5r6.in-berlin.de>
Date: Wed, 04 Apr 2007 18:33:06 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.2) Gecko/20070222 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Rene Herman <rene.herman@gmail.com>, Christoph Hellwig <hch@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: MODULE_MAINTAINER
References: <46138B4C.2050409@gmail.com> <20070404123311.GA18552@infradead.org> <4613A1F1.2080007@gmail.com> <20070404145726.GD27660@stusta.de>
In-Reply-To: <20070404145726.GD27660@stusta.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Wed, Apr 04, 2007 at 03:02:41PM +0200, Rene Herman wrote:
>> Given modules with multiple authors, current and non-current, I believe 
>> having "modinfo -m" tell the user whom to contact is an avantage.
> 
> Much bigger problems are:
> - Who will maintain this information properly?
> - What about modules that are maintained implicitely by the subsystem
>   maintainer?
> 
> And often a user can't be expected to locate the source of a problem, or 
> it might not be in a driver but in a subsystem.
> 
> For vendor kernels, the user should contact the vendor.
> For ftp.kernel.org kernels, I don't see any better solution than telling 
> people to report problems to linux-kernel or the kernel Bugzilla and 
> routing them further from here.

Generelly it has to be kept in mind that there are different contacts
for different purposes:
  - usage problems --> get in touch with the _support_
  - bug reports --> get in touch with _maintainers_
  - development --> get in touch with maintainers/ kernel hackers/
    copyright holders...

The Amiga keyboard had a [Help] key, but this is not how it works.
-- 
Stefan Richter
-=====-=-=== -=-- --=--
http://arcgraph.de/sr/
