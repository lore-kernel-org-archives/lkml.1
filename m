Return-Path: <linux-kernel-owner+w=401wt.eu-S1754927AbYJGEVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927AbYJGEVp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 00:21:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750761AbYJGEVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 00:21:37 -0400
Received: from kroah.org ([198.145.64.141]:44576 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750727AbYJGEVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 00:21:36 -0400
Date: Mon, 6 Oct 2008 21:19:33 -0700
From: Greg KH <greg@kroah.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sysfs: Remove sysfs_do_create_link().
Message-ID: <20081007041933.GA14843@kroah.com>
References: <20080917130805.6260ba9c@gondolin.boeblingen.de.ibm.com> <m1r67i61rh.fsf@frodo.ebiederm.org> <20080918090705.6985cced@gondolin.boeblingen.de.ibm.com> <m17i99wz7k.fsf@frodo.ebiederm.org> <20080918125056.03c404e8@gondolin.boeblingen.de.ibm.com> <m1y71pvg5d.fsf@frodo.ebiederm.org> <20080918142806.20568dda@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080918142806.20568dda@gondolin.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2008 at 02:28:06PM +0200, Cornelia Huck wrote:
> Since sysfs_create_link_nowarn() is gone, sysfs_do_create_link()
> is an unneeded indirection: Remove it.

Is this still needed, now that I've dropped Eric's patchset?

thanks,

greg k-h
