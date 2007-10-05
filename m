Return-Path: <linux-kernel-owner+w=401wt.eu-S1762713AbXJEAMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762713AbXJEAMX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 20:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760150AbXJEAMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 20:12:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59589 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760110AbXJEAMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 20:12:14 -0400
Message-ID: <47058144.6030208@zytor.com>
Date: Thu, 04 Oct 2007 17:11:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.23-rc9-git2: Known regressions from 2.6.22
References: <200710050011.12433.rjw@sisk.pl>
In-Reply-To: <200710050011.12433.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> 
> Subject:	vga text console not working on 2.6.23-rc8
> Submitter:	Santiago Garcia Mantinan <manty@manty.net>
> References:	http://lkml.org/lkml/2007/9/28/342
> 		http://bugzilla.kernel.org/show_bug.cgi?id=9099
> Handled-By:	H. Peter Anvin <hpa@zytor.com>
> 		Antonino A. Daplas <adaplas@gmail.com>
> 

This one was user error.  Not a regression.

	-hpa
