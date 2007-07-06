Return-Path: <linux-kernel-owner+w=401wt.eu-S1763618AbXGFKXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763618AbXGFKXA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 06:23:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755300AbXGFKWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 06:22:53 -0400
Received: from zakalwe.fi ([80.83.5.154]:40796 "EHLO zakalwe.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760266AbXGFKWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 06:22:52 -0400
Date: Fri, 6 Jul 2007 13:22:38 +0300
From: Heikki Orsila <shdl@zakalwe.fi>
To: Gautam Singaraju <gautam.singaraju@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: RSA support into kernel?
Message-ID: <20070706102238.GE3400@zakalwe.fi>
References: <f8b2ccd40707051548w275a1575oaaddffd40d9a9163@mail.gmail.com> <f8b2ccd40707051753v7cba58cfw1d3e0df5e4decc6d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <f8b2ccd40707051753v7cba58cfw1d3e0df5e4decc6d@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2007 at 05:53:11PM -0700, Gautam Singaraju wrote:
> Is there any attempt being made to provide software based RSA
> cryptographic support in kernel?

I fail to see how it would be useful. RSA is such a slow operation that 
doing it in userspace is efficient and safer.

-- 
Heikki Orsila			Barbie's law:
heikki.orsila@iki.fi		"Math is hard, let's go shopping!"
http://www.iki.fi/shd
