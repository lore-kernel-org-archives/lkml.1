Return-Path: <linux-kernel-owner+w=401wt.eu-S1423543AbXEANxM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423543AbXEANxM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 09:53:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423539AbXEANxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 09:53:12 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:3144 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423543AbXEANxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 09:53:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=n390qHBI5iHYTfoPj/MuOJnirJMFiwVnNmOzRa1yfLmYd/u9FwM/kZEbXEWlRE6R4I8jqTe3d1QaFW1Fo+/MBNjlSPa51mZXwumxiKgeLlUIprXoo2oJCLXspuoJYB7KZcsD345HO2fGcJbi+zpysVJUsiqbwDpva8JeX5uN2O0=
Message-ID: <46374645.2030900@gmail.com>
Date: Tue, 01 May 2007 17:53:09 +0400
From: Dmitry Krivoschekov <dmitry.krivoschekov@gmail.com>
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: Paul Sokolovsky <pmiscml@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       kernel-discuss@handhelds.org
Subject: Re: [RFC, PATCH 0/4] SoC base drivers
References: <1354376306.20070501080806@gmail.com>
In-Reply-To: <1354376306.20070501080806@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

Paul Sokolovsky wrote:
> In contemporary systems, lots of functionality oftentimes handled by various
> kinds of SoCs (system-on-chip), representing a number of deversified
> controllers packaged in one chip. 

I think your referring to the term "SoC (system-on-chip)" is confusing
(at least for me). You rather consider companion chips than SoCs.

Yes, any chip integrating a number of controllers could be considered
as a system-on-chip but if the chip doesn't make sense without
some master chip (processor) I'd consider the chip as a companion
(to the processor) chip.


Regards,
Dmitry
