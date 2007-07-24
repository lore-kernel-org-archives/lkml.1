Return-Path: <linux-kernel-owner+w=401wt.eu-S1763966AbXGXTQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763966AbXGXTQW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 15:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751646AbXGXTQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 15:16:12 -0400
Received: from gw.goop.org ([64.81.55.164]:51334 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750787AbXGXTQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 15:16:11 -0400
Message-ID: <46A64FC1.5050808@goop.org>
Date: Tue, 24 Jul 2007 12:15:13 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Tilman Schmidt <tilman@imap.cc>, Olaf Hering <olh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Gabriel C <nix.or.die@googlemail.com>
Subject: Re: 2.6.22-git17 boot failure
References: <46A481FD.2030607@imap.cc> <46A4C081.6070305@goop.org> <46A504A3.3070205@imap.cc> <46A51079.5030006@goop.org> <46A53396.2060902@imap.cc> <46A5444D.4080304@goop.org> <20070724091018.GA26724@one.firstfloor.org> <20070724095614.GB625@suse.de> <46A64019.4010508@imap.cc> <46A64CD5.2030800@goop.org> <20070724191231.GA359@one.firstfloor.org>
In-Reply-To: <20070724191231.GA359@one.firstfloor.org>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Yes 10.2 mkinitrd does. But it still should work because a dom0
> kernel would obviously need all the drivers. A paravirt ops
> kernel native is like a dom0 variant.
>
> http://firstfloor.org/~andi/mkinitrd

Well, it appears to be assuming that a dom0 Xen kernel will have stuff
in /proc/xen/.

    J

