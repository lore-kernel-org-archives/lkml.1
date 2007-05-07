Return-Path: <linux-kernel-owner+w=401wt.eu-S932224AbXEGKlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224AbXEGKlm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 06:41:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932263AbXEGKll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 06:41:41 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55208 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932224AbXEGKlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 06:41:40 -0400
Date: Mon, 7 May 2007 11:41:17 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org, marcelo@kvack.org,
       linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Re: Please pull 'libertas' branch of wireless-2.6
Message-ID: <20070507104117.GA31601@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Jeff Garzik <jeff@garzik.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, marcelo@kvack.org,
	linux-kernel@vger.kernel.org, akpm@osdl.org
References: <20070227205649.GH5826@tuxdriver.com> <45E8CF5E.5090305@garzik.org> <20070303052140.GA31075@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070303052140.GA31075@infradead.org>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 03, 2007 at 05:21:40AM +0000, Christoph Hellwig wrote:
> Umm, I can't remember the updated driver ever beeig posted for review.
> And to be honest I'd be surprised if it's in a good shape already.

Of course it's not anywhere near good shape.  Almost all items from my
review were completely ignored, and we have another totoally substandard
wireless driver with crappy thread handling, a huge number of broken private
ioctls and partially absymal codingstyle.

And I didn't even get a reply to my mail addressing the concerns above.
