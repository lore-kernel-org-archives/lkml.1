Return-Path: <linux-kernel-owner+w=401wt.eu-S1757565AbYFZSxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565AbYFZSxT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 14:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753219AbYFZSxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 14:53:06 -0400
Received: from mxl.seznam.cz ([77.75.72.44]:54947 "EHLO mxl.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752356AbYFZSxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 14:53:05 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=beta; d=seznam.cz;
	h=Received:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Smtpd:X-Seznam-User:X-QM-Mark;
	b=ET/wY31GlAI1ZdyErQzRnrqSgJQIxe+aBMlP0wz+yHdGDbha9mcJOUKS/z2Vt1VKS
	VzbcRYZwpyc27QSPl0RK2mj9gvCL2XE6JEiXIcy40SzMOJe2OjRK4JH+coonJAEQVz6
	lhEsN9kyP8wwJ9TSAcL2QZf3z9gG2Fz6Dj5U0Ns=
Message-ID: <4863E4FD.6040803@seznam.cz>
Date: Thu, 26 Jun 2008 20:50:37 +0200
From: Michal Simek <monstr@seznam.cz>
Reply-To: monstr@seznam.cz
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: linux-kernel@vger.kernel.org, arnd@arndb.de, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, linuxppc-dev@ozlabs.org,
       vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk, hpa@zytor.com
Subject: Re: Microblaze init port v4
References: <1214483429-32360-1-git-send-email-monstr@seznam.cz> <20080626150121.GB22025@cs181140183.pp.htv.fi>
In-Reply-To: <20080626150121.GB22025@cs181140183.pp.htv.fi>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
X-Smtpd: 1.1.1@13338
X-Seznam-User: monstr@seznam.cz
X-QM-Mark: email-qm3<130501742>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adrian,

> On Thu, Jun 26, 2008 at 02:29:29PM +0200, monstr@seznam.cz wrote:
>> Hi everybody,
>>
>> current linux version is 2.6.26-rc8 and I think this is the right time
>> to send latest patches againts rc8 for Microblaze CPU.
>> ...
> 
> Thanks for your work on getting the architecture included.
> 
> I have two questions:
> 
> Where can I find a toolchain for compiling a Microblaze kernel?
I personally use petalogix toolchain from www.petalogix.com.

> What is the status of Microblaze support in upstream binutils and gcc?

I don't have any information about. We will discuss with John Williams and guys
from Xilinx
what we can do for it.

M

>> Best regards,
>> Michal Simek
> 
> TIA
> Adrian
> 
> 
> 
> ------------------------------------------------------------------------
> 
> 
> No virus found in this incoming message.
> Checked by AVG. 
> Version: 8.0.101 / Virus Database: 270.4.1/1519 - Release Date: 25.6.2008 04:13
