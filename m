Return-Path: <linux-kernel-owner+w=401wt.eu-S1756828AbZBZAGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828AbZBZAGw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 19:06:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757362AbZBZAGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 19:06:36 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56361 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224AbZBZAGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 19:06:35 -0500
Message-ID: <49A5DC30.4080803@zytor.com>
Date: Wed, 25 Feb 2009 16:02:56 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: arnd@arndb.de
CC: Sam Ravnborg <sam@ravnborg.org>, Kyle McMartin <kyle@infradead.org>,
       Ingo Molnar <mingo@elte.hu>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>, mingo@redhat.com,
       dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [patch 0/7] Use strict kernel types to fix the world
References: <20090225235138.062045835@arndb.de>
In-Reply-To: <20090225235138.062045835@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arnd@arndb.de wrote:
> I've gone through the files again and fixed up all
> non-strict types I could find. I did not check all
> architectures for this though.
> 
> I split out netfilter, DRM and MTD, because of both
> size and potentially controversial changes.

I take it this supercedes your previous monolithic patch?

	-hpa
