Return-Path: <linux-kernel-owner+w=401wt.eu-S1755665AbZKDMCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665AbZKDMCh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 07:02:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755601AbZKDMCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 07:02:36 -0500
Received: from cantor.suse.de ([195.135.220.2]:39490 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755557AbZKDMCg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 07:02:36 -0500
Date: Wed, 4 Nov 2009 13:02:40 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: =?ISO-8859-15?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
Cc: linux list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] trivial: fix assorted typos all over the place
In-Reply-To: <b8bf37780911020949t4bed5cb6g92230b59efc7923b@mail.gmail.com>
Message-ID: <alpine.LSU.2.00.0911041300360.9988@wotan.suse.de>
References: <b8bf37780911020949t4bed5cb6g92230b59efc7923b@mail.gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="168427776-7152138-1257336160=:9988"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--168427776-7152138-1257336160=:9988
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Mon, 2 Nov 2009, André Goddard Rosa wrote:

> This patch fixes assorted typos all over the place.
> 
> That is "success", "unknown", "through", "performance", "[re|un]mapping"
> , "access", "default", "reasonable", "[con]currently", "temperature"
> , "channel", "[un]used", "application", "example","hierarchy" and others.

One more request though (I think I'll explicitly mention this in 
SubmittingPatches so that it's there for future submitters) -- could you 
please separate the drivers/staging bits out of it, and send them 
separately to Greg?

Staging drivers are area where a lot of things happen every day, so it's 
easy to get a conflict there, and therefore it's better to handle these 
kinds of changes directly in Greg's tree.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
--168427776-7152138-1257336160=:9988--
