Return-Path: <linux-kernel-owner+w=401wt.eu-S1753978AbYCQEFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978AbYCQEFz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 00:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750977AbYCQEFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 00:05:48 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:51069 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827AbYCQEFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 00:05:47 -0400
Date: Sun, 16 Mar 2008 21:04:21 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Rob Landley <rob@landley.net>, Greg KH <gregkh@suse.de>,
       Samuel Masham <samuel.masham@gmail.com>, stable@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [stable] 2.6.24.3 broke "make headers_install".
Message-ID: <20080317040421.GU4416@sequoia.sous-sol.org>
References: <93564eb70802241736l741e7406o29fab05a611c12c7@mail.gmail.com> <93564eb70803101913n2ede72d1i33279772440c9afa@mail.gmail.com> <20080311033306.GB9198@suse.de> <200803161709.52389.rob@landley.net> <20080316151426.4b4baf09.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080316151426.4b4baf09.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Randy Dunlap (randy.dunlap@oracle.com) wrote:
> Yes, it's been reported a few times already and should be fixed/reverted
> in the next stable release.

Yup, fix is queued up.

thanks,
-chris
