Return-Path: <linux-kernel-owner+w=401wt.eu-S1755489AbZAIUJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489AbZAIUJg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 15:09:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753016AbZAIUJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 15:09:24 -0500
Received: from vms044pub.verizon.net ([206.46.252.44]:56784 "EHLO
	vms044pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155AbZAIUJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 15:09:23 -0500
Date: Fri, 09 Jan 2009 15:09:17 -0500 (EST)
From: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] misc: Add oqo-wmi driver for model 2 OQO backlight and
 rfkill control
In-reply-to: <20090109123506.GB31003@srcf.ucam.org>
X-X-Sender: lenb@localhost.localdomain
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "Brian S. Julin" <bri@abrij.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, greg@kroah.com
Message-id: <alpine.LFD.2.00.0901091507510.16697@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <20081127190517.GA25429@srcf.ucam.org>
 <alpine.LFD.2.00.0811281431320.3204@localhost.localdomain>
 <Pine.LNX.4.64.0811282215160.17453@sheavy.abrij.org>
 <20081129045045.GA13866@srcf.ucam.org> <20081203195537.GB22560@srcf.ucam.org>
 <alpine.LFD.2.00.0901090112190.4091@localhost.localdomain>
 <20090109123506.GB31003@srcf.ucam.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Matthew,
> > this refreshed patch sits in my test tree from about a month ago.
> > I guess i was expecting you to reply to the three comments on it before 
> > pushing it upstream.
> 
> Ah, sorry, I didn't realise you'd picked it up. I'm still trying to find 
> some time to spend with the hardware to make sure a cleaned up version 
> works correctly.

No sweat, just wanted you to know that v1 is in acpi test
and thus will be in linux-next because of it.
It will patiently wait there until you're ready to refresh it.

cheers,
-Len
