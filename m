Return-Path: <linux-kernel-owner+w=401wt.eu-S1753225AbYIMRMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225AbYIMRMg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 13:12:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752176AbYIMRM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 13:12:28 -0400
Received: from senator.holtmann.net ([87.106.208.187]:37504 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155AbYIMRM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 13:12:26 -0400
Subject: Re: [NONSERIOUS PATCH]: Change Sun serial major/minor numbers...
From: Marcel Holtmann <holtmann@linux.intel.com>
To: David Miller <davem@davemloft.net>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org, joy@entuzijast.net
In-Reply-To: <20080912.212013.205659677.davem@davemloft.net>
References: <20080912.212013.205659677.davem@davemloft.net>
Content-Type: text/plain
Date: Sat, 13 Sep 2008 19:13:01 +0200
Message-Id: <1221325981.6695.49.camel@californication>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

> This is the non-serious patch I mentioned in my first posting
> which changes all of the major/minor numbers used by the Sun
> serial drivers in order to get out of the way of 8250's
> major/minor namespace.
> 
> Again, this patch isn't meant to be taken seriously at all.
> I'm not even willing to sign off on it :-)

as long as you are using udev, it wouldn't that big of a problem :)

Regards

Marcel


