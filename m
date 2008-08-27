Return-Path: <linux-kernel-owner+w=401wt.eu-S1754768AbYH0Gqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768AbYH0Gqd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 02:46:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752320AbYH0GqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 02:46:23 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:36319 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752555AbYH0GqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 02:46:22 -0400
Date: Wed, 27 Aug 2008 08:46:16 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Shawn Starr <shawn.starr@rogers.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6.27-rc2.git1] (Fedora snapshot) Realtek gigE network
	driver showing bogus packet drops
Message-ID: <20080827064616.GA11625@electric-eye.fr.zoreil.com>
References: <200808262059.57667.shawn.starr@rogers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808262059.57667.shawn.starr@rogers.com>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shawn Starr <shawn.starr@rogers.com> :
[...]
> The dropped count increments even with no traffic. The machine has not been
> suspended/resumed. Anyone else noticed this?

Please try the patch attached to:

http://bugzilla.kernel.org/show_bug.cgi?id=10180

As a side request, I will welcome the output of an 'mii-tool -vv' (for a
completely different purpose).

-- 
Ueimor
