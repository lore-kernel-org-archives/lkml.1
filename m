Return-Path: <linux-kernel-owner+w=401wt.eu-S937262AbYEVKYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937262AbYEVKYf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 06:24:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937185AbYEVKX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 06:23:58 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:60775 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937184AbYEVKX4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 06:23:56 -0400
Message-ID: <48354966.5050508@pobox.com>
Date: Thu, 22 May 2008 06:22:30 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Christoph Raisch <raisch@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       Thomas Klein <tklein@de.ibm.com>, linux <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>,
       Christophe Jaillet <christophe.jaillet@wanadoo.fr>
Subject: Re: [PATCH] drivers/net/ehea - remove unnecessary memset after kzalloc
References: <20080512213601.626C91C0008F@mwinf2103.orange.fr> <1210628297.14967.16.camel@localhost>
In-Reply-To: <1210628297.14967.16.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>

applied


