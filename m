Return-Path: <linux-kernel-owner+w=401wt.eu-S1161469AbXB0ASz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161469AbXB0ASz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 19:18:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161471AbXB0ASz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 19:18:55 -0500
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:54558 "EHLO
	fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161469AbXB0ASy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 19:18:54 -0500
Date: Tue, 27 Feb 2007 01:16:40 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: "Boris B. Zhmurov" <bb@kernelpanic.ru>
Cc: Pascal GREGIS <pgs@synerway.com>, linux-kernel@vger.kernel.org
Subject: Re: need some help on a backport of r8169
Message-ID: <20070227001640.GB5384@electric-eye.fr.zoreil.com>
References: <20070226160824.GB14593@venus.synerway.com> <45E31248.7000301@kernelpanic.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45E31248.7000301@kernelpanic.ru>
User-Agent: Mutt/1.4.2.1i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Boris B. Zhmurov <bb@kernelpanic.ru> :
[...]
> to your 2.6.11. Francois, please, correct me, if I'm wrong.

It will regularly DMA into incorrectly aligned addresses. :o/

Surprizing as it may sound, the symptoms range from unnoticeable
to unusable (both inclusive).

-- 
Ueimor
