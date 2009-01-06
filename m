Return-Path: <linux-kernel-owner+w=401wt.eu-S1756269AbZAFXDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756269AbZAFXDi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 18:03:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756353AbZAFXDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 18:03:14 -0500
Received: from relay2.sgi.com ([192.48.179.30]:57754 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756303AbZAFXDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 18:03:12 -0500
Date: Tue, 6 Jan 2009 17:03:07 -0600
From: Jack Steiner <steiner@sgi.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 31/60] SGI: struct device - replace bus_id with dev_name(), dev_set_name()
Message-ID: <20090106230306.GA127225@sgi.com>
References: <20090106221123.GA32689@kroah.com> <1231279939-32728-31-git-send-email-gregkh@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231279939-32728-31-git-send-email-gregkh@suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2009 at 02:11:50PM -0800, Greg Kroah-Hartman wrote:
> From: Kay Sievers <kay.sievers@vrfy.org>
> 
> CC: Jack Steiner <steiner@sgi.com>
> Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> ---
>  drivers/misc/sgi-gru/grumain.c |    2 +-


Acked-by: Jack Steiner <steiner@sgi.com>


--- jack
