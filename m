Return-Path: <linux-kernel-owner+w=401wt.eu-S1755096AbZINKGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096AbZINKGi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 06:06:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754027AbZINKGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 06:06:37 -0400
Received: from senator.holtmann.net ([87.106.208.187]:49195 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631AbZINKGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 06:06:36 -0400
Subject: Re: [GIT] HID patches for 2.6.32 merge window
From: Marcel Holtmann <marcel@holtmann.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LNX.2.00.0909132014310.17028@wotan.suse.de>
References: <alpine.LNX.2.00.0909132014310.17028@wotan.suse.de>
Content-Type: text/plain
Date: Mon, 14 Sep 2009 03:06:34 -0700
Message-Id: <1252922794.3421.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

> could you please pull from 'for-linus' branch of
> 
>         git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus
> 
> to receive HID patches accumulated for 2.6.32 merge window.

I am missing the patch to free the transport drivers from having to
manually disconnect hidinput and hidraw. All the hid->claimed handling
should really be hidden from the transport drivers.

Regards

Marcel


