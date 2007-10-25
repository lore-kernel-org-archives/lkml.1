Return-Path: <linux-kernel-owner+w=401wt.eu-S1757056AbXJYBus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757056AbXJYBus (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 21:50:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753567AbXJYBuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 21:50:40 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:61062 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728AbXJYBuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 21:50:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Nlyu90CtwslXBg/llQk4UKT/EO//bAEbaNjy5TRvAYiAM+orY3rHKWHyAHJxM9uyr2Ge5QNuxWkJp5ayEh6swJzFwVHiwcER9IX9o0q18U4qJkGL3AIItwkM54I42OlUs136DyfZa++bAvEercc61+dv9AwtdGG9c4mG76aZq9A=
Subject: SPI doesn't detect first dataflash (CS0) on a AT91rm9200ek with
	kernel 2.6.23.1
From: Bruno =?ISO-8859-1?Q?V=E9tel?= <bvetel@gmail.com>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 25 Oct 2007 03:49:49 +0200
Message-Id: <1193276989.7052.32.camel@rigel.esas.fr>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

I want to use SPI on a at91rm9200ek. The SPI starts and the dataflash is
probed but fails with error 255. I tried on another board very similar
to at91rm9200ek but with 4 dataflashs (chip select 0 to 3). The flashs
1 2 3 are well detected but the 0 fails also with the same error code.
Debug traces tells all transfers seems to be OK. The board with 4
dataflashs works well with a 2.6.17 + patch at91. I don't find any
answers to my problem.


Could you help me ?

Thanks

Bruno


