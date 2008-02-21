Return-Path: <linux-kernel-owner+w=401wt.eu-S934866AbYBUXjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934866AbYBUXjZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 18:39:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755649AbYBUXjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 18:39:13 -0500
Received: from one.firstfloor.org ([213.235.205.2]:33574 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755098AbYBUXjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 18:39:11 -0500
Message-ID: <47BE0C03.4000904@firstfloor.org>
Date: Fri, 22 Feb 2008 00:40:51 +0100
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Marcel Holtmann <marcel@holtmann.org>
CC: Simon Richter <sjr@debian.org>, Tilman Schmidt <tilman@imap.cc>,
       Gregory Nietsky <gregory@networksentry.co.za>,
       Jeff Garzik <jeff@garzik.org>, kkeil@suse.de, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, isdn4linux@listserv.isdn4linux.de,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: Plans for mISDN? Was: [PATCH 00/14] [ISDN] ...
References: <098123kjff90231nv098233rnvd908u234@garzik.org>	<20080217195235.GN14588@uranus.ravnborg.org>	<20080218045209.GA15141@kroah.com> <p73zltyxy9q.fsf@bingen.suse.de>	<20080219085033.GA1775@uranus.ravnborg.org>	<47BAA072.9050601@networksentry.co.za> <47BC370F.3000705@imap.cc> <47BD5360.5070706@debian.org> <AC06F991-72AC-4DFB-825A-F046C1943F10@holtmann.org> <47BE06EB.6010301@firstfloor.org> <5F9B7248-82DA-43F1-8937-8B52D5146298@holtmann.org>
In-Reply-To: <5F9B7248-82DA-43F1-8937-8B52D5146298@holtmann.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> we were talking about the load order. This will solve the load order,
> but if we have races like the kind you described, then the whole mISDN
> design is broken. 

It's more a generic problem of the module code.

-Andi
