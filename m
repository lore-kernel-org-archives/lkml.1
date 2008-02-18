Return-Path: <linux-kernel-owner+w=401wt.eu-S1758553AbYBREnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758553AbYBREnz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 23:43:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756199AbYBREnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 23:43:46 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:47280 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756128AbYBREnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 23:43:45 -0500
Date: Sun, 17 Feb 2008 20:48:34 -0800
From: Greg KH <greg@kroah.com>
To: Jonas Bonn <jonas@southpole.se>
Cc: linux-kernel@vger.kernel.org, olof@lixom.net, sam@ravnborg.com
Subject: Re: [PATCH] Add PCI_DEVICE_TABLE macro
Message-ID: <20080218044834.GB14184@kroah.com>
References: <1203250205-5103-1-git-send-email-jonas@southpole.se> <1203250404.24325.1.camel@satguru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203250404.24325.1.camel@satguru>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 17, 2008 at 01:13:24PM +0100, Jonas Bonn wrote:
> I'm a bit uncertain whether the definition really should include the
> 'static' modifier... for most definitions of these tables this is ok,
> but there are a couple of cases where it should not be static, so the
> line would need to be open-coded again...

Yes, please don't make it static.

And again, what does this buy us?

thanks,

greg k-h
