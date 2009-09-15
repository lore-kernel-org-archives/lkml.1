Return-Path: <linux-kernel-owner+w=401wt.eu-S1753335AbZIOLpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335AbZIOLpW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 07:45:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752950AbZIOLpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 07:45:19 -0400
Received: from mail001.aei.ca ([206.123.6.130]:33323 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753185AbZIOLpR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 07:45:17 -0400
From: Ed Tomlinson <edt@aei.ca>
To: Pekka Enberg <penberg@cs.helsinki.fi>, Nitin Gupta <ngupta@vflare.org>
Subject: Re: [PATCH 2/4] virtual block device driver (ramzswap)
Date: Tue, 15 Sep 2009 07:45:14 -0400
User-Agent: KMail/1.11.4 (Linux/2.6.31-crc; KDE/4.2.4; x86_64; ; )
References: <200909100215.36350.ngupta@vflare.org> <d760cf2d0909142339i30d74a9dic7ece86e7227c2e2@mail.gmail.com> <84144f020909150030h1f9d8062sc39057b55a7ba6c0@mail.gmail.com>
In-Reply-To: <84144f020909150030h1f9d8062sc39057b55a7ba6c0@mail.gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Ed Tomlinson <edt@aei.ca>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-mm-cc@laptop.org, Ingo Molnar <mingo@elte.hu>,
       =?iso-8859-1?q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Greg KH <greg@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909150745.16265.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 September 2009 03:30:23 you wrote:
> > So, its extremely difficult to wait for the proper fix.
> 
> Then make ramzswap depend on !CONFIG_ARM. In any case, CONFIG_ARM bits
> really don't belong into drivers/block.

Problem is that ramzswap is usefull on boxes like the n800/n810...  So this is a bad
suggestion from my POV.    How about a comment saying this code goes when the 
fix arrives???

Ed Tomlinson
