Return-Path: <linux-kernel-owner+w=401wt.eu-S1760894AbXFAABf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760894AbXFAABf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 20:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755498AbXFAAB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 20:01:29 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:22871 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671AbXFAAB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 20:01:28 -0400
Date: Thu, 31 May 2007 17:00:29 -0700
From: Zach Brown <zach.brown@oracle.com>
To: Jeff Dike <jdike@addtoit.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: [PATCH] Syslets - Fix cachemiss_thread return value
Message-ID: <20070601000029.GN5488@mami.zabbo.net>
References: <20070531181923.GA9904@c2.user-mode-linux.org> <20070531220716.GL5488@mami.zabbo.net> <20070531233946.GA12493@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070531233946.GA12493@c2.user-mode-linux.org>
User-Agent: Mutt/1.4.2.1i
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> the demos I sent out.  Dunno about the existing ones, but I bet they do
> the same.

Hmm, they didn't when I ran them, but I'll give yours a try and take a
closer look.  Thanks for taking the time to bring it up.

- z
