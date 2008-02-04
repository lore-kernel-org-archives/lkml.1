Return-Path: <linux-kernel-owner+w=401wt.eu-S1755389AbYBDV6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389AbYBDV6V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 16:58:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754119AbYBDV6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 16:58:13 -0500
Received: from gate.crashing.org ([63.228.1.57]:47444 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755367AbYBDV6M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 16:58:12 -0500
Subject: Re: tg3 broken after "PCI: Fix bus resource assignment on 32 bits
	with 64b resources"
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Alexey Dobriyan <adobriyan@sw.ru>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080204151222.GB25790@localhost.sw.ru>
References: <20080204151222.GB25790@localhost.sw.ru>
Content-Type: text/plain
Date: Tue, 05 Feb 2008 08:57:28 +1100
Message-Id: <1202162248.7079.10.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oh and send me the output of /proc/iomem as well.

Cheers,
Ben.


