Return-Path: <linux-kernel-owner+w=401wt.eu-S1759898AbYCSTvI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759898AbYCSTvI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 15:51:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756000AbYCSTdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:33:49 -0400
Received: from gw.goop.org ([64.81.55.164]:54550 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755994AbYCSTds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:33:48 -0400
Message-ID: <47E16727.7050104@goop.org>
Date: Wed, 19 Mar 2008 12:19:03 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Ian Campbell <ijc@hellion.org.uk>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00 of 31] x86: unification and xen updates
References: <patchbomb.1205797011@localhost> <1205918565.4112.61.camel@zakaz.uk.xensource.com> <47E12D39.2000207@goop.org> <20080319190755.GB11432@elte.hu>
In-Reply-To: <20080319190755.GB11432@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> I'm actually having problem booting 32-on-64 hvm guests.  Specifically 
>> the Fedora installer crashes fairly early on:
>>     
>
> is this a bug that has leaked into current upstream -git as well, or is 
> it an x86.git/testing issue?

I'm assuming its a Xen bug actually.  It happens with the distro kernel 
on the installers as well as x86.git.  Googling around shows similar 
symptoms on laptops with problematic BIOSes, so that points at a 
possible problem.

    J
