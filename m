Return-Path: <linux-kernel-owner+w=401wt.eu-S1755095AbZKWSbJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095AbZKWSbJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 13:31:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753568AbZKWSbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 13:31:09 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58679
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753299AbZKWSbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 13:31:08 -0500
Date: Mon, 23 Nov 2009 10:31:25 -0800 (PST)
Message-Id: <20091123.103125.229368402.davem@davemloft.net>
To: hartleys@visionengravers.com
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: drivers/ide/tx4938ide.c: use resource_size()
From: David Miller <davem@davemloft.net>
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE190901EE5C05@mi8nycmail19.Mi8.com>
References: <BD79186B4FD85F4B8E60E381CAEE190901EE5C05@mi8nycmail19.Mi8.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H Hartley Sweeten" <hartleys@visionengravers.com>
Date: Mon, 23 Nov 2009 13:27:23 -0500

> Use resource_size() for devm_request_mem_region.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

Applied to ide-next-2.6
