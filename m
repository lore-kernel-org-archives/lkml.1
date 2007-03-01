Return-Path: <linux-kernel-owner+w=401wt.eu-S964786AbXCAJ54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964786AbXCAJ54 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 04:57:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964788AbXCAJ5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 04:57:55 -0500
Received: from smtp.osdl.org ([65.172.181.24]:37154 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964786AbXCAJ5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 04:57:55 -0500
Date: Thu, 1 Mar 2007 01:57:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: bryan.wu@analog.com
Cc: nico@cam.org, jgarzik@pobox.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 4/5] Blackfin: patch add blackfin support in smc91x
 ethernet controller driver
Message-Id: <20070301015737.6df09fcb.akpm@linux-foundation.org>
In-Reply-To: <1172741003.5264.88.camel@roc-desktop>
References: <1172722530.5264.78.camel@roc-desktop>
	<20070301005428.e5823f15.akpm@linux-foundation.org>
	<1172741003.5264.88.camel@roc-desktop>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

oh, and please consider removing all the CVS control strings from the
blackfin code.  Because they become meaningless once the code is
merged into mainline.
