Return-Path: <linux-kernel-owner+w=401wt.eu-S1754560AbYHBDc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560AbYHBDc3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 23:32:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752323AbYHBDcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 23:32:18 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:2077 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751532AbYHBDcR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 23:32:17 -0400
Date: Fri, 1 Aug 2008 23:29:46 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: davem@davemloft.net, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2008-08-01
Message-ID: <20080802032946.GA29921@tuxdriver.com>
References: <20080801205830.GA10071@tuxdriver.com> <1ba2fa240808011443u1a5553fpfca046f047773217@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ba2fa240808011443u1a5553fpfca046f047773217@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 02, 2008 at 12:43:32AM +0300, Tomas Winkler wrote:
> On Fri, Aug 1, 2008 at 11:58 PM, John W. Linville
> <linville@tuxdriver.com> wrote:
> > Dave,
> >
> > Another big batch of wireless fixes for 2.6.27.  The ath5k series is
> > more than fixes, but I included it because it enables new ath5k
> > hardware.  (The ath5k.h changes in particular are documentation cleanups
> > for registers based on info gleaned from the newly posted ath9k driver.)
> > The others patches are fixes, some more obvious than others. :-)
> >
> > Let me know if there are any problems!
> 
> All the iwlwifi patches should go up otherwise the support for 5000 HW
> will be incomplete.

Then they should have been posted before 2.6.26 was released...

-- 
John W. Linville
linville@tuxdriver.com
