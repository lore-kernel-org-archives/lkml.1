Return-Path: <linux-kernel-owner+w=401wt.eu-S1755667AbXFFHxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667AbXFFHxV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 03:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752125AbXFFHxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 03:53:14 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43999 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751363AbXFFHxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 03:53:13 -0400
Date: Wed, 6 Jun 2007 00:53:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Doug Thompson <norsk5@yahoo.com>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/36] drivers edac remove depends on X86
Message-Id: <20070606005304.bec91e29.akpm@linux-foundation.org>
In-Reply-To: <123360.2742.qm@web50106.mail.re2.yahoo.com>
References: <123360.2742.qm@web50106.mail.re2.yahoo.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Jun 2007 07:39:06 -0700 (PDT) Doug Thompson <norsk5@yahoo.com> wrote:

> Remove the 'depends on x86' as EDAC runs on other ARCHs now.

Not on alpha.

drivers/edac/edac_stub.c:15:22: error: asm/edac.h: No such file or directory
