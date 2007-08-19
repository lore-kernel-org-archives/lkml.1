Return-Path: <linux-kernel-owner+w=401wt.eu-S1753976AbXHSMbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976AbXHSMbp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 08:31:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751848AbXHSMbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 08:31:37 -0400
Received: from main.gmane.org ([80.91.229.2]:46542 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751845AbXHSMbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 08:31:36 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Benny Amorsen <benny+usenet@amorsen.dk>
Subject: Re: [OT] Re: The vi editor causes brain damage
Date: Sun, 19 Aug 2007 14:31:21 +0200
Message-ID: <m37inr1zae.fsf@ursa.amorsen.dk>
References: <964583.28477.qm@web52504.mail.re2.yahoo.com> <46C7EE0A.2030601@gmail.com> <20070819072135.GQ6002@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: hd5b9080a.c45-01-12.sta.perspektivbredband.net
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
Cancel-Lock: sha1:J/2gi0UbdkGNUYXtrwXG+i5uuuw=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "WT" == Willy Tarreau <w@1wt.eu> writes:

WT> Under unix, the shell resolves "*" and passes the 10000 file names
WT> to the "rm" command. Now, execve() may fail because 10000 names in
WT> arguments can require too much memory. That's why find and xargs
WT> were invented!

It would be very handy if the argument memory space was expanded.
Many years ago I hit the limit regularly on Solaris, and going to
Linux with its comparatively large limit was a joy. Now it happens to
me quite often on Linux as well.

What are the primary problems with expanding it? It used to be
swappable memory, is that still the case?


/Benny


