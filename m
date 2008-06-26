Return-Path: <linux-kernel-owner+w=401wt.eu-S1760584AbYFZS6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760584AbYFZS6Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 14:58:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752592AbYFZS6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 14:58:13 -0400
Received: from mxl.seznam.cz ([77.75.72.44]:35240 "EHLO mxl.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752513AbYFZS6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 14:58:11 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=beta; d=seznam.cz;
	h=Received:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Smtpd:X-Seznam-User:X-QM-Mark;
	b=B2LfJkw4G+fMOg++LOEiAH/bLpDrQLRgzaUHCEoox6DuKF7bja8VtQIuQrrJ6CIc4
	5lHeuw+xUdkG5GIslLWU+blE1bAftoqli40KM9mjJHrAvWkYTVJhBB+0HxAj4yvRcGr
	mEYzf4QlC9P1qKRL/WtZPJ1ewciLL6otFed5KEE=
Message-ID: <4863E70A.2060108@seznam.cz>
Date: Thu, 26 Jun 2008 20:59:22 +0200
From: Michal Simek <monstr@seznam.cz>
Reply-To: monstr@seznam.cz
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arch@vger.kernel.org, alan@lxorguk.ukuu.org.uk, vapier.adi@gmail.com,
       matthew@wil.cx, microblaze-uclinux@itee.uq.edu.au,
       linux-kernel@vger.kernel.org, drepper@redhat.com,
       linuxppc-dev@ozlabs.org, will.newton@gmail.com, hpa@zytor.com,
       John.Linn@xilinx.com, john.williams@petalogix.com
Subject: Re: Microblaze init port v4
References: <1214483429-32360-1-git-send-email-monstr@seznam.cz> <200806261709.37045.arnd@arndb.de>
In-Reply-To: <200806261709.37045.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
X-Smtpd: 1.1.1@13338
X-Seznam-User: monstr@seznam.cz
X-QM-Mark: email-qm4<127183698>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

> On Thursday 26 June 2008, monstr@seznam.cz wrote:
>> We have there still problem with syscalls and we don't have chance to 
>> fix it to stable version, this is not part which I can do yourself. 
>> Microblaze will be n + 1 platform which use some old syscalls. 
>> I hope you understand.
> 
> That still leaves the problem that a lot of your syscalls have bugs
> copied from other platforms. If you need to maintain backwards compatibility
> with your existing binaries, that's fine, but please fix the code you are
> adding.

This is for now. I'll remove when I will have new toolchain.

I saw an email from you about.

M
