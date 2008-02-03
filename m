Return-Path: <linux-kernel-owner+w=401wt.eu-S933662AbYBCNIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933662AbYBCNIR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 08:08:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760925AbYBCNIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 08:08:05 -0500
Received: from hu-out-0506.google.com ([72.14.214.236]:64170 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759292AbYBCNIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 08:08:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=I2yw0XlSDt7/4AlTgVbbHiBtcBvujFJd81u9fBYQlsogpE5imOvBvF4dmF999eMgcmjWReCma9/UDkdS5eXWdLT/L3IcGWM4xRh/7CEzhR5eBXpTysHjNfcwQFfTl37rTnJ+2kSHLnKDTevxf3V/EIaac4rkmQY0t03ZifUdDMY=
Date: Sun, 3 Feb 2008 16:07:40 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net, bryan.wu@analog.com,
       hskinnemoen@atmel.co, dhowells@redhat.com
Subject: Re: [patch 0/4] cleanup - use _AC macro to define PAGE_SIZE
Message-ID: <20080203130740.GA11983@cvg>
References: <47a5a65d.03eb300a.07b8.130e@mx.google.com> <20080203122239.GF20810@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080203122239.GF20810@uranus.ravnborg.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Sam Ravnborg - Sun, Feb 03, 2008 at 01:22:39PM +0100]
| On Sun, Feb 03, 2008 at 02:22:17PM +0300, Cyrill Gorcunov wrote:
| > This patch series removes code duplication for PAGE_SIZE
| > definition on various architectures.
| > 
| > Please review. Any comments are welcome. *UNTESTED*
| 
| Looks good.
| Could you do a followup patch for each architecture introducing
| use of PAGE_SIZE in their respective kernel/vmlinux.lds.S too?
| I think more than your 4 listed architectures could need this fix.
| 
| 	Sam
| 

a bit *later* I mean (was a misprint ;)

		- Cyrill -
