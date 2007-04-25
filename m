Return-Path: <linux-kernel-owner+w=401wt.eu-S2992996AbXDYTpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992996AbXDYTpx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 15:45:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992973AbXDYTpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 15:45:53 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55203 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993000AbXDYTpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 15:45:52 -0400
Date: Wed, 25 Apr 2007 20:45:50 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] use mutex instead of semaphore in tty_io.c
Message-ID: <20070425194550.GA18914@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	linux-kernel@vger.kernel.org
References: <20070425154934.GP6798@traven> <20070425191359.GA13241@infradead.org> <20070425194633.GA3280@traven>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070425194633.GA3280@traven>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2007 at 09:46:33PM +0200, Matthias Kaehlcke wrote:
> thanks for your remarks. is the following patch what you are
> proposing?

Yes, exactly.  Looks good to me this way.:w


