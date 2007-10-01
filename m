Return-Path: <linux-kernel-owner+w=401wt.eu-S1753470AbXJALOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470AbXJALOv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 07:14:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751691AbXJALOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 07:14:43 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43623 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657AbXJALOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 07:14:43 -0400
Date: Mon, 1 Oct 2007 13:14:41 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Denys <nuclearcat@nuclearcat.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21 -> 2.6.22 & 2.6.23-rc8 performance regression
Message-ID: <20071001111441.GA17357@one.firstfloor.org>
References: <20070930144443.M52139@visp.net.lb> <46FFE17C.9020202@cosmosbay.com> <200709301425.37564.nickpiggin@yahoo.com.au> <20070930220452.M25621@nuclearcat.com> <p73myv36tmz.fsf@bingen.suse.de> <20071001103026.M59805@nuclearcat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071001103026.M59805@nuclearcat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2007 at 01:30:52PM +0300, Denys wrote:
> 
> Already i did, and it didn't show real failure point.

There was no difference between the profile of the working kernel
and the high load kernel?  Perhaps you just have legitimate higher load?

-Andi
