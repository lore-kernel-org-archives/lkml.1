Return-Path: <linux-kernel-owner+w=401wt.eu-S1754100AbYCXUYE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100AbYCXUYE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 16:24:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752348AbYCXUXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 16:23:54 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52924
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751952AbYCXUXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 16:23:54 -0400
Date: Mon, 24 Mar 2008 13:23:53 -0700 (PDT)
Message-Id: <20080324.132353.65713081.davem@davemloft.net>
To: samuel.thibault@ens-lyon.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH,TRIVIAL] AF_UNIX, accept() and addrlen
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080324104330.GF4434@implementation.uk.xensource.com>
References: <20080308022321.GC5853@implementation>
	<20080323.215641.192753003.davem@davemloft.net>
	<20080324104330.GF4434@implementation.uk.xensource.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Samuel Thibault <samuel.thibault@ens-lyon.org>
Date: Mon, 24 Mar 2008 10:43:30 +0000

> See documentation above.  If applications don't follow documentation,
> then they deserve breaking :)

Not when we've been reporting the existing value for more
than 10 years.
