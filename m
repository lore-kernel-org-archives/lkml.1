Return-Path: <linux-kernel-owner+w=401wt.eu-S1764780AbXKORgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764780AbXKORgk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 12:36:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757349AbXKORga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 12:36:30 -0500
Received: from ns.suse.de ([195.135.220.2]:47999 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762043AbXKORg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 12:36:28 -0500
Date: Thu, 15 Nov 2007 18:36:27 +0100
From: Jan Blunck <jblunck@suse.de>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: Re: 2.6.24-rc2-mm1
Message-ID: <20071115173627.GG25521@hasse.suse.de>
References: <20071113175906.497a1a6a.akpm@linux-foundation.org> <64bb37e0711141116h5ea9ed8cs7f2afbabe73f07bb@mail.gmail.com> <20071114122939.7b4ee194.akpm@linux-foundation.org> <64bb37e0711141448h15c667dbn4496870dd64a0457@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64bb37e0711141448h15c667dbn4496870dd64a0457@mail.gmail.com>
Organization: SUSE LINUX Products GmbH, GF Markus Rex, HRB 16746 (AG
	Nuernberg)
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, Torsten Kaiser wrote:

> > > So I can create new directories, but not new files. Reading files works normal.
> > >>
> > > The client is 2.6.24-rc2-mm1, the server 2.6.22-gentoo-r9.
> 
> I added Jan Blunck to the recipents, as he wrote
> use-struct-path-in-struct-svc_expkey and
> use-struct-path-in-struct-svc_export

These patches only change the server code. Hard to imagine how this could
break the client. The other patches are pure cleanups only.

Regards,
	Jan

-- 
Jan Blunck <jblunck@suse.de>
