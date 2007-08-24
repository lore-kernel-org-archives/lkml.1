Return-Path: <linux-kernel-owner+w=401wt.eu-S1759072AbXHXKvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759072AbXHXKvt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 06:51:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754357AbXHXKvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 06:51:42 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:50146 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753156AbXHXKvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 06:51:42 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [RFC] USB: driver for iphone charging
To: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net, Matt Colyer <matt@colyer.name>,
       jeffm@suse.de
Reply-To: 7eggert@gmx.de
Date: Fri, 24 Aug 2007 12:51:19 +0200
References: <8VtFd-7mx-51@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1IOWl6-0000iK-5t@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX18ylU24rG59hDEfgylnvP/GEv3NR3w0jVYZ99U
 guadY7eQ9lABkpHNYEDCz8CrrEl1NwMgnOgnQAmXWDSgMJ5VxT
 cs8IO94Ty9pGBW+7XXi1A==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <greg@kroah.com> wrote:

> my berry_charge code that adds support for charging the iphone when it
> is plugged into a Linux machine.

This should be a runtime option, because you may want to build a non-module
kernel and not charge the phone while running your laptop on battery.
-- 
Top 100 things you don't want the sysadmin to say:
72. My leave starts tomorrow.

Friﬂ, Spammer: MYowdIc@7eggert.dyndns.org
