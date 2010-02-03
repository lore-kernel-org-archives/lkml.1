Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932554Ab0BCQlL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 11:41:11 -0500
Received: from mail-yx0-f189.google.com ([209.85.210.189]:35263 "EHLO
	mail-yx0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932512Ab0BCQlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 11:41:07 -0500
MIME-Version: 1.0
In-Reply-To: <ec63e5978fd5ac5d308ede5916e648ba925818eb.1265173480.git.amit.kucheria@canonical.com>
References: <cover.1265173246.git.amit.kucheria@verdurent.com> 
	<0511204199ab83aed2340e70a4639500c0528dab.1265173480.git.amit.kucheria@canonical.com> 
	<9fa7a3c70c46a1f776c6520051481cff6525ef02.1265173480.git.amit.kucheria@canonical.com> 
	<cover.1265173480.git.amit.kucheria@canonical.com> <ccc89dd7a6035abf5a78680404a2b30b9e025353.1265173480.git.amit.kucheria@canonical.com> 
	<ec63e5978fd5ac5d308ede5916e648ba925818eb.1265173480.git.amit.kucheria@canonical.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 3 Feb 2010 09:35:12 -0700
X-Google-Sender-Auth: 012119d2e9611629
Message-ID: <fa686aa41002030835t7046ed3bk33deed2c2f631263@mail.gmail.com>
Subject: Re: [PATCHv2 04/11] mxc: changes to common plat-mxc code to add 
	support for i.MX5
To: Amit Kucheria <amit.kucheria@canonical.com>
Cc: List Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
       s.hauer@pengutronix.de, valentin.longchamp@epfl.ch, daniel@caiaq.de,
       Dinh.Nguyen@freescale.com, r.herring@freescale.com,
       bryan.wu@canonical.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 2, 2010 at 10:16 PM, Amit Kucheria
<amit.kucheria@canonical.com> wrote:
> Changes separted to help in the review process

<soapbox>Commit log needs to talk about what the patch is, not how it
has changed.  Please state what the patch does and why.  It is also
helpful to have testing information.  The goal is to make it easy for
both patch reviewers on the mailing list *and* people looking at the
commit in git after it is merged.  This commit message doesn't provide
the reader with any helpful information.

Patch version/review information like your comment above typically
goes below the '---' line.</soapbox>

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
