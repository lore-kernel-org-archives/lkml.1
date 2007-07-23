Return-Path: <linux-kernel-owner+w=401wt.eu-S1763631AbXGWOwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763631AbXGWOwr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 10:52:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758700AbXGWOwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 10:52:38 -0400
Received: from gw.goop.org ([64.81.55.164]:38481 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758227AbXGWOwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 10:52:37 -0400
Message-ID: <46A4C081.6070305@goop.org>
Date: Mon, 23 Jul 2007 07:51:45 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Tilman Schmidt <tilman@imap.cc>
CC: LKML <linux-kernel@vger.kernel.org>, andi@firstfloor.org,
       nix.or.die@googlemail.com
Subject: Re: 2.6.22-git17 boot failure
References: <46A3EC92.3050504@imap.cc> <46A3FBB7.9000608@imap.cc> <46A46BF9.6010906@goop.org> <46A481FD.2030607@imap.cc>
In-Reply-To: <46A481FD.2030607@imap.cc>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tilman Schmidt wrote:
> Attached are .config and dmesg (as captured in SuSE's /var/log/boot.msg)
> of a CONFIG_XEN=n git-current build. 

That's dmesg from a successful boot?  What does it look like when its
unsuccessful?  Where do they start to differ?

    J
