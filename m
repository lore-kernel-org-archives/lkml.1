Return-Path: <linux-kernel-owner+w=401wt.eu-S1755241AbXKLUrE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241AbXKLUrE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 15:47:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751650AbXKLUqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 15:46:53 -0500
Received: from zakalwe.fi ([80.83.5.154]:42179 "EHLO zakalwe.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751285AbXKLUqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 15:46:53 -0500
Date: Mon, 12 Nov 2007 22:46:52 +0200
From: Heikki Orsila <shdl@zakalwe.fi>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Tino Keitel <tino.keitel@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: Strage buffer behaviour
Message-ID: <20071112204652.GI8865@zakalwe.fi>
References: <20071111183334.GA6770@dose.home.local> <200711121244.54251.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <200711121244.54251.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2007 at 12:44:53PM -0700, Denys Vlasenko wrote:
> IIRC only mounted partitions' reads are cached.

That seems to be the case. Thanks.

-- 
Heikki Orsila			Barbie's law:
heikki.orsila@iki.fi		"Math is hard, let's go shopping!"
http://www.iki.fi/shd
