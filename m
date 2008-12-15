Return-Path: <linux-kernel-owner+w=401wt.eu-S1753381AbYLOGNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381AbYLOGNU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 01:13:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751237AbYLOGNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 01:13:12 -0500
Received: from kroah.org ([198.145.64.141]:53758 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751125AbYLOGNL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 01:13:11 -0500
Date: Sun, 14 Dec 2008 22:05:31 -0800
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.27.9
Message-ID: <20081215060531.GA2981@kroah.com>
References: <20081214001029.GA915@kroah.com> <pan.2008.12.14.08.06.53.334750@wizards.de> <20081214190829.GA31396@kroah.com> <49456C76.20006@wizards.de> <20081214211127.GC3928@tatooine.rebelbase.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081214211127.GC3928@tatooine.rebelbase.local>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 14, 2008 at 10:11:27PM +0100, markus reichelt wrote:
> * Holger Hoffstätte <holger@wizards.de> wrote:
> 
> > That's really all I know.
> 
> Apart from all the mainline excuses why patches aren't accepted - I'd
> REALLY like to know why each and every 2.6.27 kernel so totally fails
> on me when it comes to X ... the vesa driver refuses to come up
> with the magic to do its 75 Hz wonders of the pre .27 series.

So 2.6.26 works, but 2.6.27 does not?

Can you run git bisect to try to track this down?

thanks,

greg k-h
