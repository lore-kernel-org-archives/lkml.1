Return-Path: <linux-kernel-owner+w=401wt.eu-S1759521AbYEEOHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759521AbYEEOHl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 10:07:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759351AbYEEOG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 10:06:59 -0400
Received: from smtp1.wifiinternet.cz ([89.31.47.1]:59126 "EHLO
	bor.wifiinternet.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759319AbYEEOG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 10:06:58 -0400
Message-ID: <481F14CA.8070402@seznam.cz>
Date: Mon, 05 May 2008 16:08:10 +0200
From: Michal Simek <monstr@seznam.cz>
Reply-To: monstr@seznam.cz
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH 49/56] microblaze_v2: fcntl.h sockios.h ucontext.h
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz> <643084ee3819dd169cad3c4e3565c5ff20dd3429.1209897267.git.monstr@monstr.eu> <231ae415bf52de25c69f727fd13c50d201f8ecd8.1209897267.git.monstr@monstr.eu> <200805050043.43125.arnd@arndb.de>
In-Reply-To: <200805050043.43125.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FIXED


> On Sunday 04 May 2008, monstr@seznam.cz wrote:
>>  include/asm-microblaze/fcntl.h    |  104 +++++++++++++++++++++++++++++++++++++
> 
> Use the existing asm-generic version for this.
> 
>>  include/asm-microblaze/sockios.h  |   25 +++++++++
>>  include/asm-microblaze/ucontext.h |   24 +++++++++
> 
> turn these into asm-generic versions.
> 
> 	Arnd <><
> 
> 
