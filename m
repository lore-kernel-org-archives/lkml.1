Return-Path: <linux-kernel-owner+w=401wt.eu-S1753638AbXIZXaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638AbXIZXaI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 19:30:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752086AbXIZX34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 19:29:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41924 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752008AbXIZX34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 19:29:56 -0400
Message-ID: <46FAEB5B.3000001@redhat.com>
Date: Wed, 26 Sep 2007 19:29:31 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.23-rc8: Known regressions from 2.6.22
References: <200709270127.40471.rjw@sisk.pl>
In-Reply-To: <200709270127.40471.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2007 07:27 PM, Rafael J. Wysocki wrote:
> 
> Subject:	Regression in 2.6.23-pre Was: Problems with 2.6.23-rc6 on AMD Geode LX800
> Submitter:	Joerg Pommnitz <pommnitz@yahoo.com>
> References:	http://lkml.org/lkml/2007/9/26/91
> 		http://bugzilla.kernel.org/show_bug.cgi?id=9086
> Caused-By:	H. Peter Anvin <hpa@zytor.com>
> 		commit 4fd06960f120e02e9abc802a09f9511c400042a5
> 		Use the new x86 setup code for i386
> Handled-By:	H. Peter Anvin <hpa@zytor.com>
> Patch:		http://lkml.org/lkml/2007/9/26/374
> 

Patch was just merged.
