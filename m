Return-Path: <linux-kernel-owner+w=401wt.eu-S1753410AbXFZIud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410AbXFZIud (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 04:50:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751343AbXFZIuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 04:50:23 -0400
Received: from gate.in-addr.de ([212.8.193.158]:51817 "EHLO mx.in-addr.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751348AbXFZIuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 04:50:22 -0400
Date: Tue, 26 Jun 2007 10:50:07 +0200
From: Lars Marowsky-Bree <lmb@suse.de>
To: Pavel Machek <pavel@suse.cz>, Chris Mason <chris.mason@oracle.com>
Cc: James Morris <jmorris@namei.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       Crispin Cowan <crispin@novell.com>, Greg KH <greg@kroah.com>,
       Andreas Gruenbacher <agruen@suse.de>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation, pathname matching
Message-ID: <20070626085007.GX20105@marowsky-bree.de>
References: <20070621192407.GF20105@marowsky-bree.de> <Line.LNX.4.64.0706211530290.483@localhost.localdomain> <20070621195400.GK20105@marowsky-bree.de> <1182459594.20464.16.camel@moss-spartans.epoch.ncsc.mil> <20070622003436.GB6222@think.oraclecorp.com> <Line.LNX.4.64.0706212044590.2100@localhost.localdomain> <20070622121742.GC6222@think.oraclecorp.com> <Line.LNX.4.64.0706220858170.5751@localhost.localdomain> <20070622140240.GM6222@think.oraclecorp.com> <20070625151411.GB1018@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070625151411.GB1018@elf.ucw.cz>
X-Ctuhulu: HASTUR
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007-06-25T17:14:11, Pavel Machek <pavel@suse.cz> wrote:

> Actually, I surprised Lars a lot by telling him ln /etc/shadow /tmp/
> allows any user to make AA ineffective on large part of systems -- in
> internal discussion. (It is not actually a _bug_, but it is certainly
> unexpected).

Pavel, no, you did not. You _did_ surprise me by misquoting me so badly,
though.

I agreed that actions by not mediated processes can interfere with
mediated processes. That is a given. So you do not give them free access
to a world writable directory.



Regards,
    Lars

-- 
Teamlead Kernel, SuSE Labs, Research and Development
SUSE LINUX Products GmbH, GF: Markus Rex, HRB 16746 (AG Nürnberg)
"Experience is the name everyone gives to their mistakes." -- Oscar Wilde

