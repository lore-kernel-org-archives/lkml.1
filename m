Return-Path: <linux-kernel-owner+w=401wt.eu-S1752965AbXDKPBM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965AbXDKPBM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 11:01:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752389AbXDKPBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 11:01:12 -0400
Received: from www17.your-server.de ([213.133.104.17]:1462 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbXDKPBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 11:01:11 -0400
Message-ID: <1176303669.461cf83552b1b@213.133.104.17>
Date: Wed, 11 Apr 2007 17:01:09 +0200
From: thomas@m3y3r.de
To: Soeren Sonnenburg <kernel@nn7.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: evdev* devices change major/minors after suspend/resume (udev?)
References: <1176283247.14106.10.camel@localhost>
In-Reply-To: <1176283247.14106.10.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) 3.2.5
X-Originating-IP: 129.35.231.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zitat von Soeren Sonnenburg <kernel@nn7.de>:

> 
> Very concrete it is this evdev that may be missing... and just FYI this
> also seems to cause trouble in Xorg - sometimes the appletouch mouse is
> not yet back...
> 
>
/dev/input/by-id/usb-Apple_Computer_Apple_Internal_Keyboard_._Trackpad-event-kbd
> -> ../event5
> 
> Any hints welcome,

See also this discussion thread:

http://www.uwsg.iu.edu/hypermail/linux/kernel/0703.3/0988.html

But there is no solution for this problem right now.

with kind regards
thomas

