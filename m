Return-Path: <linux-kernel-owner+w=401wt.eu-S1754615Ab0AZE2H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615Ab0AZE2H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 23:28:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754583Ab0AZE1z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 23:27:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59941 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754554Ab0AZE1i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 23:27:38 -0500
Date: Mon, 25 Jan 2010 20:26:44 -0800
From: Greg KH <gregkh@suse.de>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Jason Baron <jbaron@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Tom Zanussi <tzanussi@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 00/12] perf lock: New subcommand "perf lock", for
	analyzing lock statistics
Message-ID: <20100126042644.GB31666@suse.de>
References: <1264167553-6510-1-git-send-email-mitake@dcl.info.waseda.ac.jp> <20100122164248.GA2651@redhat.com> <a6b9f31a1001250615y6e4501b3k17074bcc4ce26c7c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a6b9f31a1001250615y6e4501b3k17074bcc4ce26c7c@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 25, 2010 at 11:15:33PM +0900, Hitoshi Mitake wrote:
> But, perf depends on debugfs.
> I don't know about production box well,
> does your production box turns on debugfs?
> It seems that debugfs is not a thing for production box...

Not true, it is enabled in many "enterprise" distros these days.

thanks,

greg k-h
