Return-Path: <linux-kernel-owner+w=401wt.eu-S1757204AbZFVSMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757204AbZFVSMo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 14:12:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756080AbZFVSMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 14:12:35 -0400
Received: from mail-fx0-f224.google.com ([209.85.220.224]:49645 "EHLO
	mail-fx0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756882AbZFVSMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 14:12:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=h/d3x8D9ytVG8p69Him3ZrscqANrdCmTSOkHv1HdSMsUNod8vlRVELjQhcDM5Gj+wS
         DU0IOw8cKd6ZDJFqLkN7vS9SikAYzB5UgUbV1/CKJrXV8NcmcYp3xZ8ns0+5/100w41x
         BZirUKdV6j+ttdTZ7dnslf2bqWmQG7D4o1GF4=
MIME-Version: 1.0
In-Reply-To: <8db1092f0906221037m30c7966bx6870b4eeb9ee16ea@mail.gmail.com>
References: <8db1092f0906211002y2b391212ve2902fc3a6517586@mail.gmail.com>
	 <8db1092f0906220019x1560c26dsd5a6daa3ea612ec@mail.gmail.com>
	 <4A3F55C7.4030909@linux.intel.com>
	 <8db1092f0906220453k5595998er1400567cbcdf3e12@mail.gmail.com>
	 <4A3F7A93.5080004@linux.intel.com>
	 <8db1092f0906220627w61d9f97g88c91f770f732f03@mail.gmail.com>
	 <4A3F8BF7.6010406@linux.intel.com>
	 <8db1092f0906220755v55699d5cj697b9bdf48978bd9@mail.gmail.com>
	 <4A3FB7BE.9080203@linux.intel.com>
	 <8db1092f0906221037m30c7966bx6870b4eeb9ee16ea@mail.gmail.com>
Date: Mon, 22 Jun 2009 20:12:36 +0200
Message-ID: <8db1092f0906221112y241abc19nb2b0a4a75ef253b4@mail.gmail.com>
Subject: Re: 2.6.30-git(16 and 17) system hangs after resume from suspend to 
	disk, mce related?
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/22 Maciej Rutecki <maciej.rutecki@gmail.com>:

> I already do this test:
> 1. boot, check_interval=0*
> 2. suspend to disk
> 3. wait 10 minutes
> 4. resume
5. After resume uptime shows 15 minutes
6. wait 15 minutes; nothing happen

*Note: I change check_interval for machinecheck0 and machinecheck1.

Perform any else tests?
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
