Return-Path: <linux-kernel-owner+w=401wt.eu-S1753317AbXJVR4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317AbXJVR4q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 13:56:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752101AbXJVR4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 13:56:40 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:48813 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553AbXJVR4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 13:56:39 -0400
Message-ID: <471CE453.5050208@tiscali.nl>
Date: Mon, 22 Oct 2007 19:56:35 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Ray Lee <ray-lk@madrabbit.org>
CC: Rik van Riel <riel@redhat.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] return hidden bug
References: <471BF741.2020501@tiscali.nl>	 <20071021214209.1a7567d7@bree.surriel.com> <2c0942db0710220942he5e9199i2e327df3c5676a6a@mail.gmail.com>
In-Reply-To: <2c0942db0710220942he5e9199i2e327df3c5676a6a@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ray Lee wrote:

> I'm sorry, perhaps I poured myself a cup of stupid this morning, but
> isn't the above patch effectively introducing a BUG where none could
> be reached before? In other words, for the patch to have zero
> behavioral change, wouldn't it have to remove the BUG() altogether?

True, but obviously not intended. I think the intention was to expose this bug.

