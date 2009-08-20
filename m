Return-Path: <linux-kernel-owner+w=401wt.eu-S1755498AbZHTXJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498AbZHTXJY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 19:09:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755404AbZHTXJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 19:09:23 -0400
Received: from mx.odn.de ([212.34.160.79]:56743 "EHLO mx.odn.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755379AbZHTXJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 19:09:23 -0400
X-Greylist: delayed 3353 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Aug 2009 19:09:23 EDT
Date: Fri, 21 Aug 2009 00:13:22 +0200
From: mmi <mmi@odn.de>
To: linux-kernel@vger.kernel.org
Subject: AMD K10 temp.module ready since months, but missing in kernel...
Message-ID: <20090821001322.470bb177@p4laptop>
Reply-To: mmi@superbash.de
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.5; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello out there,

i found the code to read temperature of AMD K10 (Phenom) processors a
couple of months ago in the net (GPL). I use it since January now and i
wonder, why it's not in the kernel till now.

It's from the same author, who wrote k8temp.c (which is in kernel).

Thanks,

M. Miederer
