Return-Path: <linux-kernel-owner+w=401wt.eu-S1751600AbXDCDms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751600AbXDCDms (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 23:42:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751611AbXDCDms
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 23:42:48 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:21372 "EHLO
	asav01.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbXDCDms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 23:42:48 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HAKhpEUZKhRO4UGdsb2JhbACHPIhDAQEq
From: Dmitry Torokhov <dtor@insightbb.com>
To: Li Yu <raise.sail@gmail.com>
Subject: Re: [linux-usb-devel] [RFC] HID bus design overview.
Date: Mon, 2 Apr 2007 23:42:47 -0400
User-Agent: KMail/1.9.3
Cc: Marcel Holtmann <marcel@holtmann.org>, Jiri Kosina <jkosina@suse.cz>,
       yanghong@ccoss.com.cn,
       linux-usb-devel <linux-usb-devel@lists.sourceforge.net>,
       hongzhiyi@ccoss.com.cn, LKML <linux-kernel@vger.kernel.org>
References: <200703051532096508636@gmail.com> <1175532439.5815.375.camel@violet> <4611AAC1.8050303@gmail.com>
In-Reply-To: <4611AAC1.8050303@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704022342.48439.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 April 2007 21:15, Li Yu wrote:
> 
> If we don't use "flip-flopping" means, the common driver and specific
> driver concepts also don't need. They are completely same driver for HID
> bus, just one without some hooks, another without.

Exactly. I am glad we are getting on the same page.

-- 
Dmitry
