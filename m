Return-Path: <linux-kernel-owner+w=401wt.eu-S1752384AbYIBMUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752384AbYIBMUd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 08:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751248AbYIBMUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 08:20:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50072 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751239AbYIBMUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 08:20:24 -0400
Date: Tue, 2 Sep 2008 13:20:06 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: device-mapper development <dm-devel@redhat.com>
Cc: "Alan D. Brunelle" <Alan.Brunelle@hp.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [dm-devel] Re: Problem w/ CONFIG_DEBUG_BLOCK_EXT_DEVT
Message-ID: <20080902122006.GN15123@agk.fab.redhat.com>
Mail-Followup-To: device-mapper development <dm-devel@redhat.com>,
	"Alan D. Brunelle" <Alan.Brunelle@hp.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Jens Axboe <jens.axboe@oracle.com>
References: <48BD173B.3090600@hp.com> <48BD19B1.9040207@kernel.org> <48BD1BA5.1020604@hp.com> <48BD1E30.8040602@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48BD1E30.8040602@kernel.org>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2008 at 01:06:24PM +0200, Tejun Heo wrote:
> Well, dev_t is 32bits and MINORBITS is 20.  So, major 12 bits, minor 20
> bits, so 4 characters for major, 7 characters for minor.
 
Upstream libdevmapper CVS patched - will appear in next release (1.02.28).

Alasdair
-- 
agk@redhat.com
