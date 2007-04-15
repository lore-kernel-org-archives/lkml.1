Return-Path: <linux-kernel-owner+w=401wt.eu-S1753153AbXDOCHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153AbXDOCHS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 22:07:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753170AbXDOCHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 22:07:18 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:5792 "EHLO
	asav13.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153AbXDOCHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 22:07:17 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aj0KAKAlIUZKhRO4UGdsb2JhbACPfQEBKlQ
From: Dmitry Torokhov <dtor@insightbb.com>
To: lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] Hardware monitoring subsystem =?iso-8859-1?q?maintainer=09positionis?= open
Date: Sat, 14 Apr 2007 22:07:15 -0400
User-Agent: KMail/1.9.3
Cc: Hans de Goede <j.w.r.degoede@hhs.nl>, Krzysztof Helt <krzysztof.h1@wp.pl>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       LKML <linux-kernel@vger.kernel.org>
References: <20070410150227.1bac05b5@hyperion.delvare> <461dca480d7ec@wp.pl> <461DDF7D.1060101@hhs.nl>
In-Reply-To: <461DDF7D.1060101@hhs.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704142207.16800.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday 12 April 2007 03:27, Hans de Goede wrote:
> Krzysztof Helt wrote:
> 
> >> * Must follow kernel coding style guidelines
> > 
> > Is there any tool to check this? If there is one, a basic
> > instruction how to use it would be great.
> > 
> 
> No tool.

Passing new drivres through scripts/Lindent and analyzing the
dirrerences can highlight differences between kernel style and
author's (note that I do not advocate mechanically passing
everything though Lindent).

-- 
Dmitry
