Return-Path: <linux-kernel-owner+w=401wt.eu-S1756257AbXFZI5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257AbXFZI5g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 04:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751882AbXFZI52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 04:57:28 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:21891 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbXFZI50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 04:57:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Z7mFqgKIqVj29cfTcljjztmG05aaghIMEmcj6xNc/Xxs8sYyqK3UpYW1tom935GzszMBFexviW6ld+OBYkJIcIGB4y6K2aWzG8WVT+ght0FqCIbsdF6UOc6sOey4Repw6N3gVvUTLBfUy9K3dYa+EO6tqCKhuXXmjYOs3Q+N8E0=
Subject: Re: Add INPUT support to toshiba_acpi
From: Richard Hughes <hughsient@gmail.com>
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: John Belmonte <john@neggie.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       Bastien Nocera <hadess@hadess.net>
In-Reply-To: <200706260703.22994.eike-kernel@sf-tec.de>
References: <1180614979.2693.26.camel@localhost.localdomain>
	 <200706231656.39597.eike-kernel@sf-tec.de> <1182765156.2519.0.camel@work>
	 <200706260703.22994.eike-kernel@sf-tec.de>
Content-Type: text/plain
Date: Tue, 26 Jun 2007 09:56:35 +0100
Message-Id: <1182848195.2335.0.camel@work>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-06-26 at 07:03 +0200, Rolf Eike Beer wrote:
> Richard Hughes wrote:
> > On Sat, 2007-06-23 at 16:56 +0200, Rolf Eike Beer wrote:
> > > None of the above keys generated a key event. Neither does
> "Brightness
> > > down", but it still works. "Brightness up" generates an event and
> works.
> > > Kpowersave tells me it can't do brightness switching in software
> (which
> > > works in WinXtraPain).
> Yes, I need a special process running for this. Would it be of some
> use if I take a look with IRPtracker on it or is that all you need to
> know?

Yes, although this is out of my area or expertise, sorry.

Richard.


