Return-Path: <linux-kernel-owner+w=401wt.eu-S1755555AbYHKPsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555AbYHKPsc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 11:48:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752348AbYHKPsY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 11:48:24 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:15482 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762AbYHKPsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 11:48:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent:sender;
        b=o9tAN4AD+pvwXzobPjsCb720u6l44vtkimeSOd9u8BlepOn6dV7ZqbDzUuS/EIgHqj
         qluCpClv+QaUnw6uYAjzzmJlNHjNlITPp5h9AB7BIypKNBCy2gWeD17NfBhqtbk2M3GU
         nm5ABlK6VAZL/Sf4xzN2IbpE+KsEV0WqjzyMw=
Date: Mon, 11 Aug 2008 21:18:12 +0530
From: Rabin Vincent <rabin@rab.in>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Eric Sesterhenn <snakebyte@gmx.de>
Subject: Re: [Bug #11270] BUG when doing a cat
	/sys/devices/system/cpu/cpuidle/current_driver
Message-ID: <20080811154812.GB1667@debian>
References: <VYYCiQF4qDI.A.BPH.KCjnIB@albercik> <cX_-nNkxKaF.A.7EB.GDjnIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cX_-nNkxKaF.A.7EB.GDjnIB@albercik>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 10, 2008 at 12:43:51AM +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.26.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11270
> Subject		: BUG when doing a cat /sys/devices/system/cpu/cpuidle/current_driver
> Submitter	: Eric Sesterhenn <snakebyte@gmx.de>
> Date		: 2008-08-05 12:33 (5 days old)
> References	: http://marc.info/?l=linux-kernel&m=121793969102438&w=4
> Handled-By	: Rabin Vincent <rabin@rab.in>
> Patch		: http://marc.info/?l=linux-kernel&m=121795955208618&w=4

Needs to be open.  The patch is in -mm, but is not yet in mainline.

Rabin
