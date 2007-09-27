Return-Path: <linux-kernel-owner+w=401wt.eu-S1755966AbXI0Lw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966AbXI0Lw6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 07:52:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752474AbXI0Lwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 07:52:51 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42599 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407AbXI0Lwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 07:52:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Chuck Ebbert <cebbert@redhat.com>
Subject: Re: 2.6.23-rc8: Known regressions from 2.6.22
Date: Thu, 27 Sep 2007 14:06:59 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <200709270127.40471.rjw@sisk.pl> <46FAEB5B.3000001@redhat.com>
In-Reply-To: <46FAEB5B.3000001@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709271406.59778.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 27 September 2007 01:29, Chuck Ebbert wrote:
> On 09/26/2007 07:27 PM, Rafael J. Wysocki wrote:
> > 
> > Subject:	Regression in 2.6.23-pre Was: Problems with 2.6.23-rc6 on AMD Geode LX800
> > Submitter:	Joerg Pommnitz <pommnitz@yahoo.com>
> > References:	http://lkml.org/lkml/2007/9/26/91
> > 		http://bugzilla.kernel.org/show_bug.cgi?id=9086
> > Caused-By:	H. Peter Anvin <hpa@zytor.com>
> > 		commit 4fd06960f120e02e9abc802a09f9511c400042a5
> > 		Use the new x86 setup code for i386
> > Handled-By:	H. Peter Anvin <hpa@zytor.com>
> > Patch:		http://lkml.org/lkml/2007/9/26/374
> > 
> 
> Patch was just merged.

Bug closed.

Thanks,
Rafael
