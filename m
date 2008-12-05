Return-Path: <linux-kernel-owner+w=401wt.eu-S1755964AbYLEBEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964AbYLEBEg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 20:04:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752716AbYLEBE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 20:04:26 -0500
Received: from vps1.tull.net ([66.180.172.116]:56348 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751968AbYLEBEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 20:04:25 -0500
Date: Fri, 5 Dec 2008 12:04:21 +1100
From: Nick Andrew <nick@nick-andrew.net>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, Jesper Juhl <jesper.juhl@gmail.com>,
       Joe Perches <joe@perches.com>
Subject: Re: linux-next: trivial tree
Message-ID: <20081205010421.GA31220@mail.local.tull.net>
References: <alpine.LNX.1.10.0811271145180.19853@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0811271145180.19853@jikos.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2008 at 11:49:59AM +0100, Jiri Kosina wrote:
> I have taken over trivial patches maintainership from Jesper.

FYI, you might (still) have a patch in your tree from me called
'Tighten Use of Loose' which fixes spelling errors in a number of
files across the repository. It's been a few months and I noticed it's
not yet in Linus' repository, presumably due to it conflicting with
functional changes done in the subsystems. So I've split it into
one-patch-per-file now and I'll submit to the subsystem maintainers
individually, with the help of Joe Perches' annotated MAINTAINERS
file and email lookup script.

Nick.
