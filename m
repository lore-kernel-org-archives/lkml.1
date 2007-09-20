Return-Path: <linux-kernel-owner+w=401wt.eu-S1756681AbXITUDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681AbXITUDY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 16:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756668AbXITUBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 16:01:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39930 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756656AbXITUBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 16:01:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: Re: [BUG]: ACPI wakup devices (/proc/acpi/wakeup) don't wake the system anymore after hibernation
Date: Thu, 20 Sep 2007 22:14:27 +0200
User-Agent: KMail/1.9.5
Cc: Maxim Levitsky <maximlevitsky@gmail.com>, linux-kernel@vger.kernel.org
References: <200709201813.28497.maximlevitsky@gmail.com> <200709201237.27469.lenb@kernel.org> <200709201937.03492.maximlevitsky@gmail.com>
In-Reply-To: <200709201937.03492.maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709202214.27513.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 20 September 2007 19:37, Maxim Levitsky wrote:
> On Thursday 20 September 2007 18:37:27 Len Brown wrote:
> > On Thursday 20 September 2007 12:13, Maxim Levitsky wrote:
[--snip--]
> > 
> 
> 
> Hi,
> 
> Well, what can I say....
> Big big thanks, works perfectly.
> 
> All resume device work after suspend to disk, and I was able to WOL the system
> while it is suspended to disk.

Len, the patch is already in my patchset, please push upstream.

Greetings,
Rafael
