Return-Path: <linux-kernel-owner+w=401wt.eu-S1752377AbZKFCk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377AbZKFCk7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 21:40:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751507AbZKFCk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 21:40:59 -0500
Received: from gate.crashing.org ([63.228.1.57]:54593 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904AbZKFCk6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 21:40:58 -0500
Subject: Re: More Huawei modem woes
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: fangxiaozhi <huananhu@huawei.com>, Greg KH <greg@kroah.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1257468899.13611.254.camel@pasglop>
References: <1257468899.13611.254.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 Nov 2009 13:40:52 +1100
Message-ID: <1257475252.13611.255.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-11-06 at 11:55 +1100, Benjamin Herrenschmidt wrote:

> Of course it's always possible that a whole lot of users have been
> testing the wrong kernel and thus don't have the fix :-) But that might
> also show a different problem with those modems usb storage
> implementation.

And indeed, the user -does- have the wrong kernel...

Ben.


