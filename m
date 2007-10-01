Return-Path: <linux-kernel-owner+w=401wt.eu-S1753846AbXJAKqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846AbXJAKqn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 06:46:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751447AbXJAKqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 06:46:36 -0400
Received: from tidos.tid.es ([193.145.240.2]:46558 "EHLO correo.tid.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341AbXJAKqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 06:46:35 -0400
Date: Mon, 01 Oct 2007 12:46:08 +0200
From: Miguel <mc354@tid.es>
Subject: Re: software unplug and plug USB
In-reply-to: <4700C649.90300@wpkg.org>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Message-id: <1191235568.6014.58.camel@McM>
MIME-version: 1.0
X-Mailer: Evolution 2.10.1
Content-type: text/plain
Content-transfer-encoding: 7BIT
References: <46FCF0F5.9030004@wpkg.org> <1191224165.6014.12.camel@McM>
 <4700A44C.2010700@wpkg.org> <1191226692.6014.16.camel@McM>
 <4700C649.90300@wpkg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

if I remove ehci_hcd / uhci_hcd / ohci_hcd , some other devices like
touchscreen, GPS and keyboard could stop working.

backup_modules doesn't matter here, is my personal backup. I have tried
also to recompile some modules because some times my modem huaweis is
recognized like usb mass storage.

I will try a how to guide to do what oliver commented

"You can use the bind & unbind attributes in sysfs"

where can i find information about that?

kindest regards


On Mon, 2007-10-01 at 12:04 +0200, Tomasz Chmielewski wrote:
> ehci_hcd / uhci_hcd 
> / ohci_hcd 

