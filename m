Return-Path: <linux-kernel-owner+w=401wt.eu-S1757028AbXFLT6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757028AbXFLT6v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 15:58:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753122AbXFLT6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 15:58:44 -0400
Received: from twin.jikos.cz ([213.151.79.26]:52013 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752927AbXFLT6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 15:58:44 -0400
Date: Tue, 12 Jun 2007 21:58:39 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Hans de Goede <j.w.r.degoede@hhs.nl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Vojtech Pavlik <vojtech@suse.cz>, sbrabec@suse.cz
Subject: Re: PATCH: fix mismatch between usb-hid.c HUT find/search mapping
 and the HUT reference doc
In-Reply-To: <466EE06B.9030202@hhs.nl>
Message-ID: <Pine.LNX.4.64.0706122157120.23280@twin.jikos.cz>
References: <466EE06B.9030202@hhs.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Jun 2007, Hans de Goede wrote:

> Currently it is incorrectly mapped to find, whereas it should be mapped 
> to search. I also added missing bindings for ID 0x21f, the real find and 
> for 0x222, goto.

Hi Hans,

you are right. Will apply, thanks.

-- 
Jiri Kosina
