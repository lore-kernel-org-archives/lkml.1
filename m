Return-Path: <linux-kernel-owner+w=401wt.eu-S1755171AbZESEtb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171AbZESEtb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 00:49:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755131AbZESEtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 00:49:13 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52012
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753646AbZESEtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 00:49:12 -0400
Date: Mon, 18 May 2009 21:49:10 -0700 (PDT)
Message-Id: <20090518.214910.41457086.davem@davemloft.net>
To: elendil@planet.nl
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipv4: make default for INET_LRO consistent with help
 text
From: David Miller <davem@davemloft.net>
In-Reply-To: <200905150851.08286.elendil@planet.nl>
References: <200905150851.08286.elendil@planet.nl>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frans Pop <elendil@planet.nl>
Date: Fri, 15 May 2009 08:51:06 +0200

> Commit e81963b1 changed this config from tristate to bool.
> Add default so that it is consistent with the help text.
> 
> Signed-off-by: Frans Pop <elendil@planet.nl>

Applied, but please also reference commits by header text,
like this:

    ipv4: make default for INET_LRO consistent with help text
    
    Commit e81963b1 ("ipv4: Make INET_LRO a bool instead of tristate.")
    changed this config from tristate to bool.  Add default so that it is
    consistent with the help text.

Thanks.
