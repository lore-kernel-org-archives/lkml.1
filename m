Return-Path: <linux-kernel-owner+w=401wt.eu-S1759311AbYEFIlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759311AbYEFIlY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 04:41:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755729AbYEFIlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 04:41:10 -0400
Received: from smtp1.wifiinternet.cz ([89.31.47.1]:62910 "EHLO
	bor.wifiinternet.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755656AbYEFIlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 04:41:09 -0400
Message-ID: <482019E5.20606@seznam.cz>
Date: Tue, 06 May 2008 10:42:13 +0200
From: Michal Simek <monstr@seznam.cz>
Reply-To: monstr@seznam.cz
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: John Williams <john.williams@petalogix.com>
CC: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       John.Linn@xilinx.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH 38/56] microblaze_v2: atomic.h bitops.h byteorder.h
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz>	 <4e20213f5f296268a24955df8c951f7fba279816.1209897266.git.monstr@monstr.eu>	 <49eccf3408b90a5ebb42635493bbeef3b584acb9.1209897266.git.monstr@monstr.eu>	 <200805042358.15131.arnd@arndb.de> <1209954519.5798.74.camel@localhost>
In-Reply-To: <1209954519.5798.74.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

have someone any idea about others names of atomic.h in asm-generic?

If not - I'll choose one but not the last(atomic-wish-we-had-it-native.h). :-)

M

> On Sun, 2008-05-04 at 23:58 +0200, Arnd Bergmann wrote:
>> On Sunday 04 May 2008, monstr@seznam.cz wrote:
>>>  include/asm-microblaze/atomic.h    |  108 ++++++++++++++++++++++++++++++++++++
>> It would be cool if you could introduce this file as 
>> asm-generic/atomic-irqdisable.h or similar (can someone please
>> think of a better name?).
> 
> atomic-nonnative.h?
> 
> atomic-emulated.h?
> 
> atomic-wish-we-had-it-native.h?
> 
> 
> 
> 
> 
