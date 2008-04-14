Return-Path: <linux-kernel-owner+w=401wt.eu-S1757918AbYDNFV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757918AbYDNFV5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 01:21:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751988AbYDNFVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 01:21:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43255 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843AbYDNFVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 01:21:49 -0400
Message-ID: <4802E749.2040809@zytor.com>
Date: Sun, 13 Apr 2008 22:10:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: monstr@seznam.cz, Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
       John Williams <john.williams@petalogix.com>, jwboyer@linux.vnet.ibm.com,
       benh@kernel.crashing.org, John Linn <John.Linn@xilinx.com>,
       git-dev@xilinx.com, Grant Likely <grant.likely@secretlab.ca>,
       git@xilinx.com, microblaze-uclinux@itee.uq.edu.au,
       linux-kernel@vger.kernel.org, paulus@samba.org
Subject: Re: Microblaze Linux release
References: <48020A21.4000404@seznam.cz> <200804140538.30268.arnd@arndb.de>
In-Reply-To: <200804140538.30268.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> 
> One of the things I always wanted to have is a common location for all the
> things that get duplicated verbatim into each new architecture, like all
> the include/asm/{fcntl,ioctls,ipcbuf,mman,poll,posix_types,sem_buf}.h and
> others that define part of the syscall ABI.
> 

include/asm-generic

	-hpa
