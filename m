Return-Path: <linux-kernel-owner+w=401wt.eu-S1760488AbZB0VLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760488AbZB0VLX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 16:11:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755933AbZB0VLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 16:11:13 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:43173 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873AbZB0VLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 16:11:12 -0500
Date: Fri, 27 Feb 2009 22:13:05 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Chris Leech <christopher.leech@intel.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] net headers: cleanup dcbnl.h
Message-ID: <20090227211305.GA12654@uranus.ravnborg.org>
References: <20090227200136.31557.53143.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090227200136.31557.53143.stgit@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 27, 2009 at 12:01:36PM -0800, Chris Leech wrote:
> 1) add an include for <linux/types.h>
> 2) change dcbmsg.dcb_family from unsigned char to __u8 to be more
>    consistent with use of kernel types
> 
> Signed-off-by: Chris Leech <christopher.leech@intel.com>
Thanks Chris.

Acked-by: Sam Ravnborg <sam@ravnborg.org>

	Sam
