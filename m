Return-Path: <linux-kernel-owner+w=401wt.eu-S1754427AbZFFDy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427AbZFFDy2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 23:54:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbZFFDyV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 23:54:21 -0400
Received: from outbound.icp-qv1-irony-out2.iinet.net.au ([203.59.1.107]:22957
	"EHLO outbound.icp-qv1-irony-out2.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751794AbZFFDyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 23:54:21 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArYBAPqEKUp8qN0Z/2dsb2JhbAAI0GaECgU
X-IronPort-AV: E=Sophos;i="4.41,314,1241366400"; 
   d="scan'208";a="507367542"
Subject: Re: [PATCH] gpiolib: allow poll on gpio value
From: Ben Nizette <bn@niasdigital.com>
To: Daniel =?ISO-8859-1?Q?Gl=F6ckner?= <dg@emlix.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1244260002.22690.21.camel@linux-51e8.site>
References: <1244212590-15620-1-git-send-email-dg@emlix.com>
	 <1244260002.22690.21.camel@linux-51e8.site>
Content-Type: text/plain
Date: Sat, 06 Jun 2009 13:53:37 +1000
Message-Id: <1244260417.22690.27.camel@linux-51e8.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-06-06 at 13:46 +1000, Ben Nizette wrote:
> Using an IDR keyed to the gpio value and just allocating your useful
s/value/number

sorry :-)

	--Ben.

