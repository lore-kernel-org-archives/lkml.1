Return-Path: <linux-kernel-owner+w=401wt.eu-S1752593AbXFNCiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593AbXFNCiY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 22:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751693AbXFNCiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 22:38:16 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:48664 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661AbXFNCiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 22:38:15 -0400
Date: Thu, 14 Jun 2007 11:36:49 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Bryan Wu <bryan.wu@analog.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Blackfin updates for 2.6.22-rc4
Message-ID: <20070614023649.GA21576@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Bryan Wu <bryan.wu@analog.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <1181786785.21995.5.camel@roc-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181786785.21995.5.camel@roc-desktop>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2007 at 10:06:25AM +0800, Bryan Wu wrote:
>  107 files changed, 7034 insertions(+), 3557 deletions(-)

This has new platform support, new drivers, and so on. None of which is
suitable outside of -rc1-2. You are aware of this thing called the merge
window?

Try splitting out the critical bugfixes in to a different tree and have
that pulled for the next -rc, if you expect to get any of the fixes
merged for 2.6.22.
