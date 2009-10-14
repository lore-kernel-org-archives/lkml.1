Return-Path: <linux-kernel-owner+w=401wt.eu-S934141AbZJNOxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934141AbZJNOxm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 10:53:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934018AbZJNOxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 10:53:41 -0400
Received: from Cpsmtpm-eml106.kpnxchange.com ([195.121.3.10]:52863 "EHLO
	CPSMTPM-EML106.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933971AbZJNOxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 10:53:41 -0400
From: Frans Pop <elendil@planet.nl>
To: Earl Chew <earl_chew@agilent.com>
Subject: Re: fs/pipe.c null pointer dereference
Date: Wed, 14 Oct 2009 16:53:02 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <4AD5D476.6010103@agilent.com>
In-reply-To: <4AD5D476.6010103@agilent.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910141653.03611.elendil@planet.nl>
X-OriginalArrivalTime: 14 Oct 2009 14:53:03.0949 (UTC) FILETIME=[08517FD0:01CA4CDE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Earl Chew wrote:
> I'm working on a 2.6.21 based kernel and received the following
> oops last tonight:

2.6.21 is really rather ancient for the kernel community and I doubt anyone 
here will really want to look into issues with it, given that there's a 
realistic chance it has already been fixed since then. The current stable 
version is 2.6.31 after all.

Can you reproduce the oops with a current kernel? Have you checked if there 
have been any changes in the code you identified since 2.6.21?

Cheers,
FJP
