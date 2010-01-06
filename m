Return-Path: <linux-kernel-owner+w=401wt.eu-S1756058Ab0AFSIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058Ab0AFSIY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 13:08:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756038Ab0AFSIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 13:08:23 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:33093 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756024Ab0AFSIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 13:08:22 -0500
Subject: Re: 2.6.33-rc3 -- Intel 945GME (inteldrmfb) -- Two Tux images
 displayed  are side by side (should only show one).
From: Peter Zijlstra <peterz@infradead.org>
To: Miles Lane <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, David Airlie <airlied@linux.ie>,
       Sylvain Meyer <sylvain.meyer@worldonline.fr>,
       linux-fbdev@vger.kernel.org
In-Reply-To: <a44ae5cd1001060916s4db1d94fsb7e012ab80ce6add@mail.gmail.com>
References: <a44ae5cd1001060916s4db1d94fsb7e012ab80ce6add@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Jan 2010 19:07:43 +0100
Message-ID: <1262801263.4049.53.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-06 at 12:16 -0500, Miles Lane wrote:
> For a long time I have gotten two pictures of Tux showing up when I
> include the Tux display option in my custom kernel builds. 

Doesn't it show one for each cpu in the system?

