Return-Path: <linux-kernel-owner+w=401wt.eu-S1754081AbYFZVkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081AbYFZVkZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 17:40:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751727AbYFZVkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 17:40:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34986 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbYFZVkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 17:40:08 -0400
Message-ID: <48640C69.8000507@zytor.com>
Date: Thu, 26 Jun 2008 14:38:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: monstr@seznam.cz
CC: linux-arch@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
       Adrian Bunk <bunk@kernel.org>, vapier.adi@gmail.com, arnd@arndb.de,
       matthew@wil.cx, microblaze-uclinux@itee.uq.edu.au,
       linux-kernel@vger.kernel.org, drepper@redhat.com,
       linuxppc-dev@ozlabs.org, will.newton@gmail.com, John.Linn@xilinx.com,
       john.williams@petalogix.com
Subject: Re: [PATCH 30/60] microblaze_v4: support for a.out
References: <1214483429-32360-22-git-send-email-monstr@seznam.cz>	<1214483429-32360-23-git-send-email-monstr@seznam.cz>	<1214483429-32360-24-git-send-email-monstr@seznam.cz>	<1214483429-32360-25-git-send-email-monstr@seznam.cz>	<1214483429-32360-26-git-send-email-monstr@seznam.cz>	<1214483429-32360-27-git-send-email-monstr@seznam.cz>	<1214483429-32360-28-git-send-email-monstr@seznam.cz>	<1214483429-32360-29-git-send-email-monstr@seznam.cz>	<1214483429-32360-30-git-send-email-monstr@seznam.cz>	<1214483429-32360-31-git-send-email-monstr@seznam.cz>	<20080626143713.GE30954@cs181140183.pp.htv.fi>	<4863ECCE.2000407@seznam.cz> <4863ED98.50608@zytor.com> <48640A88.8070402@seznam.cz>
In-Reply-To: <48640A88.8070402@seznam.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Simek wrote:
>> Michal Simek wrote:
>>> I expect it but I haven't information about. I'll check it.
>> I'm assuming Microblaze doesn't actually add a.out support, does it?
> 
> I think that any support were there but I assume that no one use it.

Most other new architectures don't bother, hence the question.

	-hpa

