Return-Path: <linux-kernel-owner+w=401wt.eu-S1752098AbXAYAHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098AbXAYAHu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 19:07:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752099AbXAYAHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 19:07:50 -0500
Received: from gate.crashing.org ([63.228.1.57]:60639 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752098AbXAYAHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 19:07:49 -0500
Subject: Re: [PATCH] gpu/radeonfb: add GPU support to radeonfb
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: airlied@linux.ie
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <11696376384021-git-send-email-airlied@linux.ie>
References: <1169637623985-git-send-email-airlied@linux.ie>
	 <11696376332395-git-send-email-airlied@linux.ie>
	 <11696376362911-git-send-email-airlied@linux.ie>
	 <11696376384021-git-send-email-airlied@linux.ie>
Content-Type: text/plain
Date: Thu, 25 Jan 2007 11:07:46 +1100
Message-Id: <1169683666.24996.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-01-24 at 22:20 +1100, airlied@linux.ie wrote:
> From: Dave Airlie <airlied@linux.ie>
> 
> This patch adds support to the radeonfb driver to use the new
> GPU layer to driver the radeon.

Unfortunately, that also massively collides with a giant radeonfb update
that's been simmering on my HD for some time (mostly the work of Solomon
Peachy to support ATOM BIOS and newer cards).

I really need to finish some bits in there and push it out. Dave, you
want to push your stuff first or you prefer re-adapting your stuff on
top of mine ? I'll try to dig a patch to put in -mm for a while next
week.

Ben.


