Return-Path: <linux-kernel-owner+w=401wt.eu-S1946185AbXBCAfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946185AbXBCAfv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 19:35:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946184AbXBCAfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 19:35:50 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:53285 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946175AbXBCAft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 19:35:49 -0500
X-Sasl-enc: p0ZTtfhFBNsmUz0Rx/gmpRsbHIm8uHn6x3JqpWGgqpqc 1170462947
Date: Fri, 2 Feb 2007 22:35:36 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: akuster@mvista.com, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Nigel Cunningham <nigel@suspend2.net>
Subject: Re: [patch 1/1] PM: Adds remount fs ro at suspend
Message-ID: <20070203003536.GA619@khazad-dum.debian.net>
References: <20070202235132.EDBDF1C448@hermes.mvista.com> <20070202161611.cf8b4328.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070202161611.cf8b4328.akpm@linux-foundation.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 Feb 2007, Andrew Morton wrote:
> Well the code appears simple enough, but I've not previously heard anyone
> express a need for this feature.  But I know how to cc people who might
> have heard this.

You are, now.

We usually try to do it in userspace (and it gets ugly when we fail).  If
the kernel would do it, it would be very welcome.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
