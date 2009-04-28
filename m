Return-Path: <linux-kernel-owner+w=401wt.eu-S1758599AbZD1V3L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758599AbZD1V3L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 17:29:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757815AbZD1V2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 17:28:24 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40944 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754428AbZD1V2X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 17:28:23 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1240938062-3264-14-git-send-email-tabbott@mit.edu>
References: <1240938062-3264-14-git-send-email-tabbott@mit.edu> <1240938062-3264-1-git-send-email-tabbott@mit.edu> <1240938062-3264-2-git-send-email-tabbott@mit.edu> <1240938062-3264-3-git-send-email-tabbott@mit.edu> <1240938062-3264-4-git-send-email-tabbott@mit.edu> <1240938062-3264-5-git-send-email-tabbott@mit.edu> <1240938062-3264-6-git-send-email-tabbott@mit.edu> <1240938062-3264-7-git-send-email-tabbott@mit.edu> <1240938062-3264-8-git-send-email-tabbott@mit.edu> <1240938062-3264-9-git-send-email-tabbott@mit.edu> <1240938062-3264-10-git-send-email-tabbott@mit.edu> <1240938062-3264-11-git-send-email-tabbott@mit.edu> <1240938062-3264-12-git-send-email-tabbott@mit.edu> <1240938062-3264-13-git-send-email-tabbott@mit.edu> 
To: Tim Abbott <tabbott@MIT.EDU>
Cc: dhowells@redhat.com, Sam Ravnborg <sam@ravnborg.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH v2 13/15] mn10300: Drop unused .data.idt section.
Date: Tue, 28 Apr 2009 22:27:41 +0100
Message-ID: <1330.1240954061@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Abbott <tabbott@MIT.EDU> wrote:

> Since nothing gets put into .data.idt on this architecture, eliminate
> it from the linker script.
> 
> This change was apparently proposed previously:
> <http://lkml.indiana.edu/hypermail/linux/kernel/0802.2/2538.html>
> 
> CCing the author and people who acked that patch in case there was a
> reason it wasn't applied.
> 
> Signed-off-by: Tim Abbott <tabbott@mit.edu>
> Cc: David Howells <dhowells@redhat.com>
> Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
> Cc: Sam Ravnborg <sam@ravnborg.org>

Acked-by: David Howells <dhowells@redhat.com>
