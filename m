Return-Path: <linux-kernel-owner+w=401wt.eu-S1753064AbYJTQhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064AbYJTQhA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 12:37:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752022AbYJTQgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 12:36:52 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:47476 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996AbYJTQgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 12:36:52 -0400
Subject: Re: [PATCH 0/9] OpenVZ kernel based checkpointing/restart
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Louis.Rilling@kerlabs.com
Cc: containers@lists.linux-foundation.org, Andrey Mirkin <major@openvz.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081020111002.GQ15171@hawkmoon.kerlabs.com>
References: <1220439476-16465-1-git-send-email-major@openvz.org>
	 <1224286383.1848.65.camel@nimitz>
	 <20081020111002.GQ15171@hawkmoon.kerlabs.com>
Content-Type: text/plain
Date: Mon, 20 Oct 2008 09:36:16 -0700
Message-Id: <1224520576.1848.102.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-10-20 at 13:10 +0200, Louis Rilling wrote:
> To be fair, and since (IIRC) the initial intent was to start with OpenVZ's
> approach, shouldn't Oren answer the same questions with respect to Andrey's
> patchset?

I'm only really "supporting" Oren's patch set because he got it out way
before the OpenVZ one showed up, and has kept integrating improvements
into it to keep me interested.  The OpenVZ approach does a few things
that Oren's does not, and it *is* a bit more mature.

I'm quite willing to jump camps if there's something compelling in what
Andrey has posted, even though I've put quite a bit of time in to
reviewing and improving Oren's.  I'm looking for that "something". :)

-- Dave

