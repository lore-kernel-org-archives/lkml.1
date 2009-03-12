Return-Path: <linux-kernel-owner+w=401wt.eu-S1755296AbZCLJgL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296AbZCLJgL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 05:36:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694AbZCLJf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 05:35:56 -0400
Received: from orion2.pixelized.ch ([195.190.190.13]:49542 "EHLO
	orion.pixelized.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372AbZCLJf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 05:35:56 -0400
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Mar 2009 05:35:56 EDT
Message-ID: <49B8D63D.8030804@cateee.net>
Date: Thu, 12 Mar 2009 10:30:37 +0100
From: "Giacomo A. Catenazzi" <cate@cateee.net>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Christopher Brannon <cmbrannon@cox.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] /dev/time for Linux, inspired by Plan 9
References: <20090311200411.WPUP4619.eastrmmtao102.cox.net@eastrmimpo02.cox.net>
In-Reply-To: <20090311200411.WPUP4619.eastrmmtao102.cox.net@eastrmimpo02.cox.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christopher Brannon wrote:

> diff --git a/Documentation/time-device.txt b/Documentation/time-device.txt
> new file mode 100644
> index 0000000..c3145a0
> --- /dev/null
> +++ b/Documentation/time-device.txt
> @@ -0,0 +1,51 @@
> +/dev/time for Linux
> +===================

I would like to see this documentation also as time(4) manpage.
So maybe you can already format it in man/mdoc format.

ciao
	cate
