Return-Path: <linux-kernel-owner+w=401wt.eu-S1758662AbYG1AOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758662AbYG1AOe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 20:14:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756800AbYG1AO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 20:14:26 -0400
Received: from gate.crashing.org ([63.228.1.57]:48933 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755730AbYG1AOZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 20:14:25 -0400
Subject: Re: mISDN still breaking the allmodconfig build...
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, sfr@canb.auug.org.au,
       akpm@linux-foundation.org, torvalds@linux-foundation.org, kkeil@suse.de,
       linuxppc-dev@ozlabs.org
In-Reply-To: <20080727.170235.97056809.davem@davemloft.net>
References: <20080727.170235.97056809.davem@davemloft.net>
Content-Type: text/plain
Date: Mon, 28 Jul 2008 10:13:42 +1000
Message-Id: <1217204022.11188.139.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-07-27 at 17:02 -0700, David Miller wrote:
> More fallout from the premature mISDN driver merge:
> 
> drivers/isdn/hardware/mISDN/hfcmulti.c:5255:2: error: #error "not running on big endian machines now"

Lovely...

Ben.


