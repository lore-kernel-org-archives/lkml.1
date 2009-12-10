Return-Path: <linux-kernel-owner+w=401wt.eu-S1758623AbZLJMqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758623AbZLJMqp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 07:46:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752833AbZLJMql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 07:46:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59202 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752494AbZLJMqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 07:46:40 -0500
Date: Thu, 10 Dec 2009 10:46:40 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH 2/2] net: use compat helper functions in
 compat_sys_recvmmsg
Message-ID: <20091210124640.GA20963@ghostprotocols.net>
References: <20091210065914.GB4144@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091210065914.GB4144@osiris.boeblingen.de.ibm.com>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Dec 10, 2009 at 07:59:15AM +0100, Heiko Carstens escreveu:
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> Use (get|put)_compat_timespec helper functions to simplify the code.
> 
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>

Nice cleanup, thanks!

Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
