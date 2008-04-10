Return-Path: <linux-kernel-owner+w=401wt.eu-S1759357AbYDJRmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759357AbYDJRmT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 13:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758409AbYDJRmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 13:42:09 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:43917 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758447AbYDJRmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 13:42:08 -0400
Date: Thu, 10 Apr 2008 10:41:37 -0700
From: Greg KH <greg@kroah.com>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 5/7] PPS: serial clients support.
Message-ID: <20080410174137.GA10117@kroah.com>
References: <20080410160122.GA24899@enneenne.com> <20080410160630.GA24885@enneenne.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080410160630.GA24885@enneenne.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2008 at 06:06:30PM +0200, Rodolfo Giometti wrote:
> On Thu, Apr 10, 2008 at 06:01:22PM +0200, Rodolfo Giometti wrote:
> > Adds support for the PPS sources connected with the CD (Carrier
> > Detect) pin of a serial port.
> 
> Should I resubmit the whole patch set?

Please do.

thanks,

greg k-h
