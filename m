Return-Path: <linux-kernel-owner+w=401wt.eu-S933842AbZHEA2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933842AbZHEA2a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 20:28:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932720AbZHEA22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 20:28:28 -0400
Received: from n10.bullet.mail.mud.yahoo.com ([209.191.125.208]:36134 "HELO
	n10.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932559AbZHEA21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 20:28:27 -0400
X-Yahoo-Newman-Id: 397634.84206.bm@omp407.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=nFAk+kvfZ6+xSeTcV2y14PxQbFCbU08DYsYl6JX+AlEjuQZAz5CBEJyxvd7AWx1b4roVUe63y9l8h3ahRfi5acbeGro4mJbBI25JFo3OagvTQt4edn6Mmxj9oqHdzGhGV6HXjfupuCKCu9eocZVp2xVeCZtUuF/aRrTBTa/HBrs=  ;
X-YMail-OSG: sWIS6JwVM1li31JcDvav1KBkPOBvCc_vOPyJrGyw8qfYVDB6_Dncckk9kHQLQtygewzh_9P85UnHeGsNzcsO6IZs0s_s79NCZG6EWdcab7JSfGKAGxUA8AxC36g4K_Llm7uynt4m_hd6ZOxCAibTSZd9b.gtOnFhYwIB8LjMmb9EQoJvqWIt.wei_stPXc3dRfEGjatAG8RKzuxDGymCBvBniWiwxiJzBuPAgU4QY6vEsOOgrffs_w448ST1M8JrKqt8ZzfKlJeRgw--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Subject: Re: [PATCH] gpio: include <linux/gpio.h> not <asm/gpio.h>
Date: Mon, 3 Aug 2009 18:12:57 -0700
User-Agent: KMail/1.9.10
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
References: <200907311059.51142.hartleys@visionengravers.com>
In-Reply-To: <200907311059.51142.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908031812.57645.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 31 July 2009, H Hartley Sweeten wrote:
> Drivers should be including <linux/gpio.h> not <asm/gpio.h>.

True.  But for the record, that's the "new" way, which is
intentionally compatibe wit the "old way".  :)



