Return-Path: <linux-kernel-owner+w=401wt.eu-S1756899AbYIPR6O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899AbYIPR6O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 13:58:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752842AbYIPR57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 13:57:59 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:38471 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbYIPR55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 13:57:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SDwzvr2+iawu4wjoIimQo+NhXQXaxaE4wvn9LV6/s/SF2ckVos8PwyVG+Wf+fHQLdY
         paWC1yk7GBkYtaZd1BYXjLUHN4C2FEUW8dIKPNv/4Jalts5vTgY4oaWmW2H1pH05EsN5
         m+45Gmfi+C06iNJ7569g0sP8OrptN2M0gffcU=
Date: Tue, 16 Sep 2008 21:57:55 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Joshua Hoblitt <josh@hoblitt.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, bugme-daemon@bugzilla.kernel.org,
       j_kernel@hoblitt.com
Subject: Re: [Bugme-new] [Bug 11543] New: kernel panic: softlockup in
	tick_periodic() ???
Message-ID: <20080916175755.GF7187@lenovo>
References: <bug-11543-10286@http.bugzilla.kernel.org/> <20080911170258.aa0bea0d.akpm@linux-foundation.org> <20080912091308.GA10305@elte.hu> <20080913001306.GA9610@hoblitt.com> <20080915210635.GA16764@hoblitt.com> <20080916025431.GB16764@hoblitt.com> <alpine.LFD.1.10.0809160711360.3606@apollo.tec.linutronix.de> <20080916175629.GE7187@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080916175629.GE7187@lenovo>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Tue, Sep 16, 2008 at 09:56:29PM +0400]
...
| 
| And get apic=debug a try too please. I remember there
| was a problem with SB600 on ACPI side (but they should
| be already fixed)
| 
| 		- Cyrill -

Sorry Thomas, I meant to send the message to Joshua

		- Cyrill -
