Return-Path: <linux-kernel-owner+w=401wt.eu-S1754564AbXFNSu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564AbXFNSu3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 14:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751659AbXFNSuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 14:50:18 -0400
Received: from wx-out-0506.google.com ([66.249.82.231]:47267 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbXFNSuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 14:50:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=DvXFHGEj8WPE5r6Xt6Y7K5mEUdctas6DxY1MUhMC6ZOJcD5Ui3tyvqlNkO5Qx1pqcos/qlHGPIxxt3nFx1GhXoVGBSoZ+TucMOMFa6RIJedtsDyWb+xWsk+UX0ESxpU1trdUCFy0DodtCJ3U6bfQy1qDwIxH6z/48gprf235INw=
Date: Thu, 14 Jun 2007 22:48:36 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: coding style
Message-ID: <20070614184836.GA6520@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi to all,

a simple question the answer to witch I didn't find in CodingStyle.
Look for a code snip:

	err = foo(arg_a, arg_b, arg_c,
		arg_d);

the second line contains 'd' arg aligned with tabs only
but it could be rewritten with more elegant style (by adding
a few spaces) like this

	err = foo(arg_a, arg_b, arg_c,
		  arg_d);

so which one is preferred for the kernel?

		Cyrill

