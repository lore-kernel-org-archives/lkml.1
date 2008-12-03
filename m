Return-Path: <linux-kernel-owner+w=401wt.eu-S1755011AbYLCAa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011AbYLCAa3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 19:30:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753237AbYLCAaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 19:30:14 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43091 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbYLCAaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 19:30:13 -0500
Date: Tue, 2 Dec 2008 19:24:04 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Greg KH <greg@kroah.com>, stable@kernel.org, sfr@canb.auug.org.au,
       ath9k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [stable] [PATCH 1/3] ath9k: Handle -ENOMEM on RX gracefully
Message-ID: <20081203002404.GA22789@tuxdriver.com>
References: <1228251082-11677-1-git-send-email-lrodriguez@atheros.com> <1228251082-11677-2-git-send-email-lrodriguez@atheros.com> <1228251082-11677-3-git-send-email-lrodriguez@atheros.com> <1228251082-11677-4-git-send-email-lrodriguez@atheros.com> <20081203001253.GC14943@kroah.com> <43e72e890812021620lccafachbd8e781d283095b7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43e72e890812021620lccafachbd8e781d283095b7@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2008 at 04:20:32PM -0800, Luis R. Rodriguez wrote:
> On Tue, Dec 2, 2008 at 4:12 PM, Greg KH <greg@kroah.com> wrote:
> > I don't see this patch upstream in Linus's tree.  Am I just missing it
> > and if so, do you know the git commit id?
> 
> Nope sorry, John has yet to send his pending-fixes branch to davem and
> so forth, which would contain it AFAICT. Please correct me if I'm
> wrong John.

It has been sent, and Dave sent his pull request to Linus today
(or maybe yesterday).  I'll try to dig-up the commit IDs tomorrow.

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
