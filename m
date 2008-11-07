Return-Path: <linux-kernel-owner+w=401wt.eu-S1752339AbYKGV4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339AbYKGV4g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 16:56:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751168AbYKGV43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 16:56:29 -0500
Received: from main.gmane.org ([80.91.229.2]:42037 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163AbYKGV42 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 16:56:28 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: walt <w41ter@gmail.com>
Subject: Re: [PATCH 0/4] Fix vmalloc regression
Date: Fri, 07 Nov 2008 13:56:10 -0800
Message-ID: <gf2dhq$l1d$1@ger.gmane.org>
References: <1226097354-7523-1-git-send-email-glommer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: adsl-69-234-183-20.dsl.irvnca.pacbell.net
User-Agent: Thunderbird/3.0a2pre (X11; 2008110705)
In-Reply-To: <1226097354-7523-1-git-send-email-glommer@redhat.com>
Cc: kvm@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber Costa wrote:
> Nick,
>
> This is the whole set of patches I was talking about.
> Patch 3 is the one that in fact fixes the problem...

Yep, patch 3 works for me, thanks.  Only the 32-bit kernel
seems to need the patch, FWIW.


