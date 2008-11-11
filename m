Return-Path: <linux-kernel-owner+w=401wt.eu-S1755401AbYKKSTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbYKKSTa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 13:19:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752799AbYKKSTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 13:19:20 -0500
Received: from eazy.amigager.de ([213.239.192.238]:36955 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbYKKSTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 13:19:19 -0500
Date: Tue, 11 Nov 2008 19:19:25 +0100
From: Tino Keitel <tino.keitel@gmx.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>
Subject: Re: [stable] Suspend regression in stable kernel 2.6.27.4 on Mac
	mini Core Duo
Message-ID: <20081111181925.GA5036@dose.home.local>
Mail-Followup-To: "Rafael J. Wysocki" <rjw@sisk.pl>,
	linux-kernel@vger.kernel.org, stable@kernel.org,
	Greg KH <greg@kroah.com>
References: <20081109202830.GA7206@x61> <200811092151.57620.rjw@sisk.pl> <20081111065643.GA11757@x61> <200811111516.09163.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811111516.09163.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2008 at 15:16:08 +0100, Rafael J. Wysocki wrote:

[...]

> This really is not a good news, because this commit evidently fixes at least
> several systems.
> 
> First, let's try to remove things that we shouldn't be doing.
> 
> Please apply the patch below to 2.6.27.5 without reverting that commit and see
> if that works.

It doesn't work. 2.6.27.5 with the patch applied hangs at resume.

Regards,
Tino
