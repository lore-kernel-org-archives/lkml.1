Return-Path: <linux-kernel-owner+w=401wt.eu-S934938AbZLPRHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934938AbZLPRHZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 12:07:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762373AbZLPRHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 12:07:09 -0500
Received: from vms173007pub.verizon.net ([206.46.173.7]:41502 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762426AbZLPRHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 12:07:05 -0500
Date: Wed, 16 Dec 2009 12:06:58 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Jes Sorensen <jes.sorensen@gmail.com>
Cc: Alan Jenkins <sourcejedi.lkml@googlemail.com>, linux-acpi@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: PATCH: Toshiba Bluetooth enabler (v3)
In-reply-to: <4B211346.2000205@gmail.com>
Message-id: <alpine.LFD.2.00.0912161205580.6089@localhost.localdomain>
References: <4B192D08.9080608@gmail.com>
 <9b2b86520912080205x478b47eek2377dacdbe44a522@mail.gmail.com>
 <4B1E85A9.3030005@gmail.com>
 <9b2b86520912090517l458bc21cobbb138d460e11f53@mail.gmail.com>
 <4B211346.2000205@gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

applied, sans dependency on RFKILL where I agree with Alan
that it will probably just confuse folks who build their own kernel
rather than add significant value.

thanks,
Len Brown, Intel Open Source Technology Center

