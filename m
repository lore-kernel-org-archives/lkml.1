Return-Path: <linux-kernel-owner+w=401wt.eu-S1754892AbYFZVa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892AbYFZVa0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 17:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751426AbYFZVaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 17:30:11 -0400
Received: from mxl.seznam.cz ([77.75.72.44]:59023 "EHLO mxl.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751358AbYFZVaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 17:30:10 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=beta; d=seznam.cz;
	h=Received:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Smtpd:X-Seznam-User:X-QM-Mark;
	b=UwC6nzhp+2MXQhrEB9tYY7xrlyvZtx0tr65jCPdnLvcQWPSXCJ+4LZj7iJVQeUVY0
	K+eWOffcI6jUsvAVHN1uoth8HMjFzDQ/18p9d3dekROf0Srr+IHrKG691z5N8MhL19Q
	f/azXSUiZMmwLa9+EnXS5ocHnyRpe1NQBIoV77c=
Message-ID: <48640A88.8070402@seznam.cz>
Date: Thu, 26 Jun 2008 23:30:48 +0200
From: Michal Simek <monstr@seznam.cz>
Reply-To: monstr@seznam.cz
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: linux-arch@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
       Adrian Bunk <bunk@kernel.org>, vapier.adi@gmail.com, arnd@arndb.de,
       matthew@wil.cx, microblaze-uclinux@itee.uq.edu.au,
       linux-kernel@vger.kernel.org, drepper@redhat.com,
       linuxppc-dev@ozlabs.org, will.newton@gmail.com, John.Linn@xilinx.com,
       john.williams@petalogix.com
Subject: Re: [PATCH 30/60] microblaze_v4: support for a.out
References: <1214483429-32360-22-git-send-email-monstr@seznam.cz>	<1214483429-32360-23-git-send-email-monstr@seznam.cz>	<1214483429-32360-24-git-send-email-monstr@seznam.cz>	<1214483429-32360-25-git-send-email-monstr@seznam.cz>	<1214483429-32360-26-git-send-email-monstr@seznam.cz>	<1214483429-32360-27-git-send-email-monstr@seznam.cz>	<1214483429-32360-28-git-send-email-monstr@seznam.cz>	<1214483429-32360-29-git-send-email-monstr@seznam.cz>	<1214483429-32360-30-git-send-email-monstr@seznam.cz>	<1214483429-32360-31-git-send-email-monstr@seznam.cz>	<20080626143713.GE30954@cs181140183.pp.htv.fi>	<4863ECCE.2000407@seznam.cz> <4863ED98.50608@zytor.com>
In-Reply-To: <4863ED98.50608@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Smtpd: 1.1.1@13338
X-Seznam-User: monstr@seznam.cz
X-QM-Mark: email-qm5<124916665>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Michal Simek wrote:
>> I expect it but I haven't information about. I'll check it.
> 
> I'm assuming Microblaze doesn't actually add a.out support, does it?
> 
>     -hpa

I think that any support were there but I assume that no one use it.

M
