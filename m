Return-Path: <linux-kernel-owner+w=401wt.eu-S1751934AbXLCVfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934AbXLCVfu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 16:35:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750996AbXLCVfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 16:35:44 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:18548 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbXLCVfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 16:35:43 -0500
Date: Mon, 3 Dec 2007 13:34:06 -0800
From: Mark Fasheh <mark.fasheh@oracle.com>
To: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Cc: linux-kernel@vger.kernel.org
Subject: Re: what happened to RELATIME?
Message-ID: <20071203213406.GJ28607@ca-server1.us.oracle.com>
Reply-To: Mark Fasheh <mark.fasheh@oracle.com>
References: <056a01c835e9$5b7203f0$5267a8c0@Jocke>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <056a01c835e9$5b7203f0$5267a8c0@Jocke>
Organization: Oracle Corporation
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2007 at 09:16:15PM +0100, Joakim Tjernlund wrote:
> Looking in 2.6.23 sources it seems like only ocfs2 has added
> support for RELATIME. Was RELATIME a bad idea or is there
> some other reason other filesystems hasn't added support?

Ocfs2 just needs a bit of explicit support - as far as I recall, other file
systems should have gotten it automagically via the generic vfs changes.
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
