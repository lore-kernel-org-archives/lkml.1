Return-Path: <linux-kernel-owner+w=401wt.eu-S1756735AbYFAAuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735AbYFAAuY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 20:50:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755033AbYFAAuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 20:50:11 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:53222 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754982AbYFAAuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 20:50:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=alyNgfdmAgljIPoKxsYdS/N9ypsjkuzxj93bZ/qJqx5S+4XJeBAmNTUR6YQqVwV02T7Che++PdKSXieX3fzk8VjbOlRauW4roMxuFLH6NZn+GdW+CgKi9RHyVJfOOcjXM9TZ/RAMSaIn5MSU+ZLIXViQ8210fekwkEbNV19Tk78=
Message-ID: <4841F225.4050702@googlemail.com>
Date: Sun, 01 Jun 2008 02:49:41 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [Bug #10613] BIOS bug, APIC version is 0 for CPU#0!
References: <90LLR3uLHfN.A.NZC.LqZQIB@albercik> <UJSav77TyUB.A.NYG.MuZQIB@albercik>
In-Reply-To: <UJSav77TyUB.A.NYG.MuZQIB@albercik>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:

> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10613
> Subject		: BIOS bug, APIC version is 0 for CPU#0!
> Submitter	: Gabriel C <nix.or.die@googlemail.com>
> Date		: 2008-05-03 15:11 (29 days old)
> References	: http://www.ussg.iu.edu/hypermail/linux/kernel/0805.0/1258.html
> Handled-By	: Yinghai Lu <yhlu.kernel@gmail.com>
> Patch		: http://lkml.org/lkml/2008/5/22/493
> 
> 


Ohh I didn't saw that patch :|

I try to find the time to test it tomorrow.


Gabriel
