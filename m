Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574Ab0CGNZm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 08:25:42 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:45696 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362Ab0CGNZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 08:25:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KLrrh3ChTGKLB+j0Ro+U9GWJlZxO1o9zO2hrH0F7JBDM3vxImcvWbq/v0MwuxKIQci
         UxcG1iNgtXS7gBYLaIYpGL+GTZOvpSPcbM0uwiU0SowxZzN+ogOIZd9589lwrEY/UF3q
         ZtGdfxe5Spwb/aBe9Dn58vD9iLXX6Q1rx2T1c=
Date: Sun, 7 Mar 2010 15:25:34 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Stewart Malik <mali0037@gmail.com>, aia21@cantab.net,
       linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FS: NTFS: fix whitespace and pointer issues in mst.c
Message-ID: <20100307132534.GA4036@x200>
References: <1267962651-11217-1-git-send-email-mali0037@gmail.com>
 <20100307121601.GJ30031@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100307121601.GJ30031@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 07, 2010 at 12:16:01PM +0000, Al Viro wrote:
> On Sun, Mar 07, 2010 at 10:20:51PM +1030, Stewart Malik wrote:
> 
> [whitespace noise]
> 
> Could we please stop using misleading subjects on that kind of patches?

More, could we please stop making git-blame output useless.
