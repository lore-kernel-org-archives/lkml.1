Return-Path: <linux-kernel-owner+w=401wt.eu-S1754828AbYAMWXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828AbYAMWXX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 17:23:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754197AbYAMWXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 17:23:13 -0500
Received: from mail.cs.tut.fi ([130.230.4.42]:63145 "EHLO mail.cs.tut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754007AbYAMWXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 17:23:12 -0500
Date: Mon, 14 Jan 2008 00:23:10 +0200
From: Tuomo Valkonen <tuomov@iki.fi>
To: Theodore Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org
Subject: Re: The ext3 way of journalling
Message-ID: <20080113222310.GA20815@jolt.modeemi.cs.tut.fi>
References: <slrnfo77tv.2rr.tuomov@jolt.modeemi.cs.tut.fi> <18307.42821.166376.732473@stoffel.org> <slrnfo7auq.6m2.tuomov@jolt.modeemi.cs.tut.fi> <871w8r6ruc.fsf@barad-dur.regala.cx> <slrnfo9lqk.17l.tuomov@jolt.modeemi.cs.tut.fi> <20080110131659.GF10230@mit.edu> <20080110134111.GA6254@jolt.modeemi.cs.tut.fi> <20080112150621.GC6751@mit.edu> <20080113221301.GA18341@jolt.modeemi.cs.tut.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20080113221301.GA18341@jolt.modeemi.cs.tut.fi>
X-Archive: encrypt
X-PGP-Fingerprint: 3B2A 89E6 9468 6DC4 FEEF  D6F6 D00C A21E C004 251B
X-PGP-Key: http://modeemi.fi/~tuomov/gpg.txt.asc
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008-01-14 00:13 +0200, Tuomo Valkonen wrote:
> Also, I must say that e2fsck is brain-damaged, if it can be confused 
> by/do the stupid then when the system clock has warped by just a few
> hours, not the _days_ that a file system check interval typically is,
> and users need to specifically kludge around such misbehaviour in 
> e2fsck.

Just to clarify, I had about 60 days of uptime, and hence at least
60 days since the last FS check/mount/etc., when Linux crashed those
few days ago, and wanted to start checking disks with "9192 days since
last file system check".

-- 
Tuomo
