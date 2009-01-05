Return-Path: <linux-kernel-owner+w=401wt.eu-S1760225AbZAEAM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760225AbZAEAM2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 19:12:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751799AbZAEAMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 19:12:18 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58646
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751727AbZAEAMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 19:12:17 -0500
Date: Sun, 04 Jan 2009 16:12:20 -0800 (PST)
Message-Id: <20090104.161220.143617759.davem@davemloft.net>
To: jaswinder@infradead.org
Cc: netdev@vger.kernel.org, becker@scyld.com, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org
Subject: Re: [PATCH -net-next 4/4] starfire: use request_firmware()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1230626510.24796.28.camel@jaswinder.satnam>
References: <1230626510.24796.28.camel@jaswinder.satnam>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jaswinder Singh Rajput <jaswinder@infradead.org>
Date: Tue, 30 Dec 2008 14:11:50 +0530

> Firmware blob is big endian
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>

Applied.
