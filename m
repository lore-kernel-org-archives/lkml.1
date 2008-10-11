Return-Path: <linux-kernel-owner+w=401wt.eu-S1754032AbYJKHzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032AbYJKHzV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 03:55:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750879AbYJKHzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 03:55:09 -0400
Received: from web38207.mail.mud.yahoo.com ([209.191.124.150]:40128 "HELO
	web38207.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750756AbYJKHzI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 03:55:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=0MAnNa0EEClfeBCqEhRFM++E1zSq7aErkZ5WaGwFBlZRwl62Z38HyqDq/rPiCMsFGKTqL2UIO/7qX6IsZPbh+fdfDjKiCS0eYlU/DAgKWFPbgRpqCdp5X8LSZQl2Hj/S9vcl30WlHPCMIaw6e1LUDb2/8BbBoALtJVzvDlqaQUc=;
X-YMail-OSG: Y6LMx4EVM1lJaR92epElbsz4qG17..3gj8l5iIIITMW1BqdWqgyAAvdkSAUIS5xTbg--
X-Mailer: YahooMailRC/1096.40 YahooMailWebService/0.7.218.2
Date: Sat, 11 Oct 2008 00:55:05 -0700 (PDT)
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: [PATCH] drm: fix leak of uninitialized data to userspace (acpi_system_read_event)
To: Vegard Nossum <vegard.nossum@gmail.com>, Ingo Molnar <mingo@elte.hu>
Cc: Vegard Nossum <vegardno@ifi.uio.no>, Dave Airlie <airlied@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-ID: <974167.43188.qm@web38207.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Vegard Nossum <vegard.nossum@gmail.com>

> 
> Does that also mean that the DRM patch fixed the first one? :-)

Yes, that's "the original kmemcheck drm warning is no longer present with your patch".

Tested-by: Sitsofe Wheeler <sitsofe@yahoo.com>



      
