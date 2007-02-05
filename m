Return-Path: <linux-kernel-owner+w=401wt.eu-S964981AbXBEWPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964981AbXBEWPk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 17:15:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964982AbXBEWPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 17:15:40 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:41995 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964981AbXBEWPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 17:15:39 -0500
In-Reply-To: <20070205220745.GB32115@outpost.ds9a.nl>
References: <patchbomb.1170193181@tetsuo.zabbo.net> <df7bc026d50ec5bbdd8e.1170193183@tetsuo.zabbo.net> <20070201083611.GC18233@elte.hu> <Pine.LNX.4.64.0702011154110.3632@woody.linux-foundation.org> <20070202104900.GA13941@elte.hu> <Pine.LNX.4.64.0702020738500.15057@woody.linux-foundation.org> <20070202222110.GA1212@elte.hu> <Pine.LNX.4.64.0702021525370.5219@alien.or.mcafeemobile.com> <20070205213618.GA30923@outpost.ds9a.nl> <Pine.LNX.4.64.0702051350010.8424@woody.linux-foundation.org> <20070205220745.GB32115@outpost.ds9a.nl>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <85F9EF88-050F-4F3F-8E3D-4205338AAC56@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>
Content-Transfer-Encoding: 7bit
From: Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
Date: Mon, 5 Feb 2007 17:15:02 -0500
To: bert hubert <bert.hubert@netherlabs.nl>
X-Mailer: Apple Mail (2.752.3)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> It has me excited in any case. Once anything even remotely testable  
> appears
> (Zach tells me not to try the current code), I'll work it into MTasker
> (http://ds9a.nl/mtasker) and make it power a nameserver that does  
> async i/o,
> for use with very very large zones that aren't preloaded.

I'll be sure to let you know :)

- z
