Return-Path: <linux-kernel-owner+w=401wt.eu-S1753868AbZGTNev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868AbZGTNev (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 09:34:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753835AbZGTNet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 09:34:49 -0400
Received: from anchor-post-3.mail.demon.net ([195.173.77.134]:33012 "EHLO
	anchor-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753841AbZGTNet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 09:34:49 -0400
Message-ID: <4A647277.4000009@superbug.demon.co.uk>
Date: Mon, 20 Jul 2009 14:34:47 +0100
From: James Courtier-Dutton <James@superbug.demon.co.uk>
User-Agent: Thunderbird 2.0.0.22 (X11/20090627)
MIME-Version: 1.0
To: kernel list <linux-kernel@vger.kernel.org>
Subject: Disk access just before shutdown power off.
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

When I shutdown my Linux laptop, it does an orderly shutdown with quite
a lot of HD activity during shutdown which eventually stops when the
screen goes blank. Then there is some delay (5-10 seconds) and then a
quick flurry of HD access just before it powers itself off.
Why is this last bit of HD access needed?
Surely, if the system is shut down enough to not use the screen any
more, why does it need the HD?
I am asking, because it would be nice to disable this need of the HD
just before it powers itself off. This would allow me to lift up the
laptop just a bit earlier and place it in my backpack when the screen
blanks without having to worry about HD failure due to shock.
I think it would be nicer if the HD would shut itself down just before
the screen goes blank.

Kind Regards

James
