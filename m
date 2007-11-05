Return-Path: <linux-kernel-owner+w=401wt.eu-S1755252AbXKEWYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252AbXKEWYc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 17:24:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753879AbXKEWYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 17:24:25 -0500
Received: from alephnull.demon.nl ([83.160.184.112]:60812 "EHLO
	xi.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529AbXKEWYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 17:24:24 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=1148133259;
	d=wantstofly.org;
	h=date:from:to:cc:subject:message-id:mime-version:content-type:
	content-disposition:in-reply-to:user-agent;
	b=Ca1GCNlg14uW0YUohVxUHK+4eo0z5ucdRsvFepG060jtydbZRUEe25cc979YD
	zDdQF2j/VO/4GhbR5F6sgYoSA==
Date: Mon, 5 Nov 2007 23:24:22 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Andre Haupt <andre@bitwigglers.org>
Cc: linux-kernel@vger.kernel.org, dsaxena@plexity.net
Subject: Re: [patch 1/1] ixp23xx: fix some double includes
Message-ID: <20071105222422.GB858@xi.wantstofly.org>
References: <20071105142114.977138260@ahaupt-debian-vm.localdomain> <20071105142330.GA27398@ahaupt-debian-vm.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071105142330.GA27398@ahaupt-debian-vm.localdomain>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2007 at 03:23:30PM +0100, Andre Haupt wrote:

> From: Andre Haupt <andre@bitwigglers.org>
> Signed-off-by: Andre Haupt <andre@bitwigglers.org>

Acked-by: Lennert Buytenhek <buytenh@wantstofly.org>
