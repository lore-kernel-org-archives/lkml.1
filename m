Return-Path: <linux-kernel-owner+w=401wt.eu-S1753818AbZKWSa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818AbZKWSa2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 13:30:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752821AbZKWSa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 13:30:27 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58676
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752165AbZKWSa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 13:30:26 -0500
Date: Mon, 23 Nov 2009 10:30:44 -0800 (PST)
Message-Id: <20091123.103044.203046617.davem@davemloft.net>
To: hartleys@visionengravers.com
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: drivers/ide/ide_platform.c: use resource_size()
From: David Miller <davem@davemloft.net>
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE190901EE5C04@mi8nycmail19.Mi8.com>
References: <BD79186B4FD85F4B8E60E381CAEE190901EE5C04@mi8nycmail19.Mi8.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H Hartley Sweeten" <hartleys@visionengravers.com>
Date: Mon, 23 Nov 2009 13:24:20 -0500

> Use resource_size() for devm_{ioremap/io_port_map}.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

Also applied to ide-next-2.6, thanks.
