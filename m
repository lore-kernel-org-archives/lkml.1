Return-Path: <linux-kernel-owner+w=401wt.eu-S1751962AbZKPIdM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962AbZKPIdM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 03:33:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751882AbZKPIdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 03:33:11 -0500
Received: from mtagate2.de.ibm.com ([195.212.17.162]:35979 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825AbZKPIdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 03:33:10 -0500
Date: Mon, 16 Nov 2009 09:33:15 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: s390: move keyboard compat ioctls into tty3270 driver
Message-ID: <20091116093315.247a3985@mschwide.boeblingen.de.ibm.com>
In-Reply-To: <200911131631.18177.arnd@arndb.de>
References: <20091113150824.351347652@de.ibm.com>
	<200911131628.22005.arnd@arndb.de>
	<200911131631.18177.arnd@arndb.de>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Nov 2009 16:31:17 +0100
Arnd Bergmann <arnd@arndb.de> wrote:

> All keyboard ioctls are compatible, so we can simply
> move the compat handling into the vt and tty3270 drivers.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

I'll add the patch to the queue. Thanks ..

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

