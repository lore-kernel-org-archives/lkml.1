Return-Path: <linux-kernel-owner+w=401wt.eu-S1756037AbYKLXUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037AbYKLXUy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 18:20:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753987AbYKLXT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 18:19:59 -0500
Received: from kroah.org ([198.145.64.141]:42327 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754019AbYKLXT7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 18:19:59 -0500
Date: Wed, 12 Nov 2008 14:46:28 -0800
From: Greg KH <greg@kroah.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging/wlan-ng: kill WLAN_CPU_FAMILY and WLAN_SYSARCH
Message-ID: <20081112224628.GD27479@kroah.com>
References: <1226500540-9667-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226500540-9667-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2008 at 09:35:40AM -0500, Mike Frysinger wrote:
> The WLAN_CPU_FAMILY and WLAN_SYSARCH defines are used in all of three places
> (two of which look pretty suspect), so just kill them off rather than
> throwing up a pointless #error on processors that are not in the existing
> list.

Thanks, but this is already cleaned up in my tree with a patch from
someone else.

greg k-h
