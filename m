Return-Path: <linux-kernel-owner+w=401wt.eu-S1762300AbZLKXQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762300AbZLKXQb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:16:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761787AbZLKXQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:16:29 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40614
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761671AbZLKXQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:16:28 -0500
Date: Fri, 11 Dec 2009 15:16:34 -0800 (PST)
Message-Id: <20091211.151634.38009658.davem@davemloft.net>
To: acme@redhat.com
Cc: heiko.carstens@de.ibm.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH 2/2] net: use compat helper functions in
 compat_sys_recvmmsg
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091210124640.GA20963@ghostprotocols.net>
References: <20091210065914.GB4144@osiris.boeblingen.de.ibm.com>
	<20091210124640.GA20963@ghostprotocols.net>
X-Mailer: Mew version 6.2 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>
Date: Thu, 10 Dec 2009 10:46:40 -0200

> Em Thu, Dec 10, 2009 at 07:59:15AM +0100, Heiko Carstens escreveu:
>> From: Heiko Carstens <heiko.carstens@de.ibm.com>
>> 
>> Use (get|put)_compat_timespec helper functions to simplify the code.
>> 
>> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
>> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> Nice cleanup, thanks!
> 
> Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>

Applied.
