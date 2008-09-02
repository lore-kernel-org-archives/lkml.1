Return-Path: <linux-kernel-owner+w=401wt.eu-S1752832AbYIBK6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832AbYIBK6T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 06:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751178AbYIBK6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 06:58:10 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:51540 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248AbYIBK6J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 06:58:09 -0400
Date: Tue, 2 Sep 2008 12:57:44 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: Tejun Heo <tj@kernel.org>, device-mapper development <dm-devel@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Problem w/ CONFIG_DEBUG_BLOCK_EXT_DEVT
Message-ID: <20080902105744.GE20055@kernel.dk>
References: <48BD173B.3090600@hp.com> <48BD19B1.9040207@kernel.org> <48BD1BA5.1020604@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48BD1BA5.1020604@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02 2008, Alan D. Brunelle wrote:
> Tejun Heo wrote:
> > Hello,
> > 
> > Alan D. Brunelle wrote:
> >> I have found two problems in LVM2/DM w/ a potential new "experimental
> >> feature" in 2.6.28: CONFIG_DEBUG_BLOCK_EXT_DEVT (this is from Jens
> >> Axboe's origin/for-2.6.28 git branch)
> > 
> > It's a debug option and I don't expect it to be enabled in any
> > production kernel.
> 
> Then perhaps it should /not/ default to Y...

It has already been changed to default to 'n'.

-- 
Jens Axboe

