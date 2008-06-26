Return-Path: <linux-kernel-owner+w=401wt.eu-S1760390AbYFZSDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760390AbYFZSDb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 14:03:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760287AbYFZSCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 14:02:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59983 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440AbYFZSCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 14:02:09 -0400
Message-ID: <4863D7E3.1030705@zytor.com>
Date: Thu, 26 Jun 2008 10:54:43 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: monstr@seznam.cz, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, linuxppc-dev@ozlabs.org,
       vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk
Subject: Re: Microblaze init port v4
References: <1214483429-32360-1-git-send-email-monstr@seznam.cz> <200806261709.37045.arnd@arndb.de> <200806261951.12809.arnd@arndb.de>
In-Reply-To: <200806261951.12809.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> 
> * You are using sys_ipc and sys_socketcall instead of the
> broken-out syscalls, which is a direct consequence of following
> the i386 numbering scheme.
> 

Please pretty please kill, kill, kill...

	-hpa
