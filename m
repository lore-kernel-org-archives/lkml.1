Return-Path: <linux-kernel-owner+w=401wt.eu-S1762214AbZJOAMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762214AbZJOAMV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 20:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761700AbZJOAMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 20:12:21 -0400
Received: from Cpsmtpm-eml107.kpnxchange.com ([195.121.3.11]:61659 "EHLO
	CPSMTPM-EML107.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761685AbZJOAMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 20:12:20 -0400
From: Frans Pop <elendil@planet.nl>
To: Earl Chew <earl_chew@agilent.com>
Subject: Re: fs/pipe.c null pointer dereference
Date: Thu, 15 Oct 2009 02:11:42 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <4AD5D476.6010103@agilent.com> <200910141653.03611.elendil@planet.nl> <4AD655C0.2030202@agilent.com>
In-Reply-To: <4AD655C0.2030202@agilent.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910150211.43532.elendil@planet.nl>
X-OriginalArrivalTime: 15 Oct 2009 00:11:43.0986 (UTC) FILETIME=[13D13D20:01CA4D2C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 October 2009, Earl Chew wrote:
> Frans Pop wrote:
> > 2.6.21 is really rather ancient for the kernel community and I doubt
> > anyone here will really want to look into issues with it, given that
> > there's a realistic chance it has already been fixed since then. The
> > current stable version is 2.6.31 after all.
> >
> > Can you reproduce the oops with a current kernel? Have you checked if
> > there have been any changes in the code you identified since 2.6.21?
>
> I was mostly after some guidance. I'm happy to dig around to figure
> out what the problem is and log a bug if indeed I find one.

OK. I'm afraid I can't help you there myself, but maybe with this 
additional info someone else will.

Good luck with the hunt.
