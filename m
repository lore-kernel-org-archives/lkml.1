Return-Path: <linux-kernel-owner+w=401wt.eu-S1756241AbYB2FFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241AbYB2FFT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 00:05:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750953AbYB2FFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 00:05:05 -0500
Received: from pat.uio.no ([129.240.10.15]:45197 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750843AbYB2FFD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 00:05:03 -0500
Subject: Re: [PATCH 01/11] Security: Add hook to get full maclabel xattr
	name
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: casey@schaufler-ca.com
Cc: Christoph Hellwig <hch@infradead.org>,
       Dave Quigley <dpquigl@tycho.nsa.gov>,
       Stephen Smalley <sds@tycho.nsa.gov>, viro@ftp.linux.org.uk,
       bfields@fieldses.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       LSM List <linux-security-module@vger.kernel.org>
In-Reply-To: <710000.44550.qm@web36605.mail.mud.yahoo.com>
References: <710000.44550.qm@web36605.mail.mud.yahoo.com>
Content-Type: text/plain
Date: Thu, 28 Feb 2008 21:04:51 -0800
Message-Id: <1204261491.7213.16.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=5.0, autolearn=disabled, none)
X-UiO-Scanned: BEB883CBF3CE061C1AFC2C08FC5F28C9482B0EE7
X-UiO-SR-test: 62C7E0A7D54906B9AD7D2D631AA1FEDD39EAD450
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 28 total 7144125 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-02-28 at 17:55 -0800, Casey Schaufler wrote:

> > There should be no need for ioctls.
> 
> Sorry, but as far as I'm concerned you just threw a bunny under
> the train for no apparent reason. What have ioctls got to do with
> anything?

What part of 'interoperability' don't you get here?

There is no room for extensions that allow clients+servers to establish
arbitrary private protocols.

