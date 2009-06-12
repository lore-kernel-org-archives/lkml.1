Return-Path: <linux-kernel-owner+w=401wt.eu-S1755645AbZFLMCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645AbZFLMCt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 08:02:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751426AbZFLMCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 08:02:41 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58170 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750783AbZFLMCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 08:02:41 -0400
Date: Fri, 12 Jun 2009 13:03:52 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-kernel@vger.kernel.org
Subject: Git head build failure
Message-ID: <20090612130352.3bddfaaf@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


mm/built-in.o: In function `kmemleak_scan':
/usr/src/LINUS/2.6/GIT/Next/linux-ttydev/mm/kmemleak.c:981: undefined
reference to `_sdata'

x86-64. .config on request

Alan
