Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751416Ab0CELzT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 06:55:19 -0500
Received: from mail.sv1.nifty.com ([220.209.183.60]:37388 "EHLO
	defg303p.nifty.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750776Ab0CELzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 06:55:17 -0500
X-Greylist: delayed 709 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Mar 2010 06:55:17 EST
X-Nifty-SrcIP: [219.116.18.238]
Date: Fri, 5 Mar 2010 20:33:17 +0900
From: Ken Kawasaki <ken_kawasaki@spring.nifty.jp>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] firmware: Correct attribution of Sierra Wireless
 CIS files
Message-Id: <20100305203317.c4aa5b5c.ken_kawasaki@spring.nifty.jp>
In-Reply-To: <1267763815.2819.297.camel@localhost>
References: <1267763815.2819.297.camel@localhost>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> The only source I can find for these files is
> <http://www.sierrawireless.com/resources/faq/PC_Card/AirCard555/Aircard_Linux.tar> linked from <https://sierrawireless.custhelp.com/app/answers/detail/a_id/179/kw/linux>.
> 

SierraWireless provides the CIS by GPL (see URL below).

http://sierrawireless.custhelp.com/app/answers/detail/a_id/203/related/1/sno/0

Yes. The files below are not developed by the pcmcia-cs project
but provided by SierraWireless.

> +File: cis/SW_555_SER.cis
> +File: cis/SW_7xx_SER.cis
> +File: cis/SW_8xx_SER.cis

Ken
