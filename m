Return-Path: <linux-kernel-owner+w=401wt.eu-S1760576AbXKUIwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760576AbXKUIwS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 03:52:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757170AbXKUIwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 03:52:07 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:40229
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755753AbXKUIwG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 03:52:06 -0500
Message-Id: <47440015.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Wed, 21 Nov 2007 08:53:25 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Greg KH" <gregkh@suse.de>
Cc: <garyhade@us.ibm.com>, "lkml" <linux-kernel@vger.kernel.org>
Subject: Re: Avoid creating P2P prefetch window for expansion ROMs
References: <4742C9D7.76E4.0078.0@novell.com>
 <20071120231453.GA20462@suse.de>
In-Reply-To: <20071120231453.GA20462@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Greg KH <gregkh@suse.de> 21.11.07 00:14 >>>
>On Tue, Nov 20, 2007 at 03:49:43AM -0700, Jan Beulich wrote:
>> This patch (in its incarnation in our SLE10SP2 tree) is causing resource
>> allocation failures on one of my machines.
>
>Does the latest 2.6.23 kernel also cause these same problems?

The patch isn't in 2.6.23 afaict, I can see it only in 2.6.24-rc (which I haven't
got around to try, yet).

Jan

