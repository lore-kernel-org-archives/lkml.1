Return-Path: <linux-kernel-owner+w=401wt.eu-S1423470AbXDZAjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423470AbXDZAjw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 20:39:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423468AbXDZAjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 20:39:52 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:54299 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423470AbXDZAjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 20:39:51 -0400
Date: Thu, 26 Apr 2007 09:40:51 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: clameter@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       y-goto@jp.fujitsu.com
Subject: Re: [RFC][PATCH] syctl for selecting global zonelist[] order
Message-Id: <20070426094051.0f3c5875.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070426093112.ec2ecb00.kamezawa.hiroyu@jp.fujitsu.com>
References: <20070425121946.9eb27a79.kamezawa.hiroyu@jp.fujitsu.com>
	<Pine.LNX.4.64.0704251211070.17886@schroedinger.engr.sgi.com>
	<20070426093112.ec2ecb00.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007 09:31:12 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > 
> > So a IA64 platform with i386 sicknesses? And pretty bad case of it since I 
> > assume that the memory sizes per node are equal. Your solution of taking 
> > 4G off node 0 and then going to node 1 first must hurt some 
> > processes running on node 0. 
> I think so, too. It is because I made this as selectable option.
                        ^^^^^^^^^
                         why...

sorry.
-Kame                  

