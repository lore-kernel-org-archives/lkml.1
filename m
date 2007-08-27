Return-Path: <linux-kernel-owner+w=401wt.eu-S1752189AbXH0Hkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189AbXH0Hkd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 03:40:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750798AbXH0HkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 03:40:24 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:23279
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751190AbXH0HkX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 03:40:23 -0400
Message-Id: <46D29C22.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Mon, 27 Aug 2007 08:40:50 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Yoichi Yuasa" <yoichi_yuasa@tripeaks.co.jp>
Cc: "Martin Michlmayr" <tbm@cyrius.com>, "Jeff Garzik" <jeff@garzik.org>,
       "Greg KH" <greg@kroah.com>, <linux-ide@vger.kernel.org>,
       "Linux KernelMailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][resend] fix IDE legacy mode resources
References: <20070824115559.06250ec0.yoichi_yuasa@tripeaks.co.jp>
 <20070824152005.45167160.akpm@linux-foundation.org>
In-Reply-To: <20070824152005.45167160.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>Please discuss.

I don't think there's much to discuss - Yoichi Yuasa's changes can be simply
brought through to the other patch (of which I continue to only state that X
has a problem, the patch fixes it for me [and perhaps *only* me], and afaik
X itself still hasn't been fixed in this respect).

Jan

