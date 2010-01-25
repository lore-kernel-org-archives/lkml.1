Return-Path: <linux-kernel-owner+w=401wt.eu-S1753687Ab0AYOfK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687Ab0AYOfK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 09:35:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752823Ab0AYOfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 09:35:09 -0500
Received: from one.firstfloor.org ([213.235.205.2]:56057 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588Ab0AYOfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 09:35:04 -0500
Date: Mon, 25 Jan 2010 15:34:59 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       x86@kernel.org, oprofile-list@lists.sf.net
Subject: Re: [PATCH] Add Xeon 7500 series support to oprofile
Message-ID: <20100125143459.GB7801@basil.fritz.box>
References: <20100121222627.GA22897@basil.fritz.box> <20100125142721.GG2014@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100125142721.GG2014@erda.amd.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Patch applied to oprofile/urgent. I will try to merge it for .33.

Thanks.

> 
> I would like to see a follow on patch that changes all x86_model
> values to hex that have the extended model bit set. This would make
> the code more readable since the spec is also using bit values for
> this.

Ok, makes sense.  I'll send it later.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
