Return-Path: <linux-kernel-owner+w=401wt.eu-S1756012AbYE2Aa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012AbYE2Aa0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 20:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752241AbYE2AaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 20:30:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46696 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751379AbYE2AaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 20:30:13 -0400
Date: Wed, 28 May 2008 17:30:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] h8300: fix typo in header guard
Message-Id: <20080528173009.4fcd504e.akpm@linux-foundation.org>
In-Reply-To: <20080527160750.GA7550@damson.getinternet.no>
References: <20080527160750.GA7550@damson.getinternet.no>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 May 2008 18:07:50 +0200
Vegard Nossum <vegard.nossum@gmail.com> wrote:

> I'm not sure who exactly to mail this as I couldn't find a MAINTAINERS
> entry for the arch

UCLINUX FOR RENESAS H8/300
P:      Yoshinori Sato
M:      ysato@users.sourceforge.jp
W:      http://uclinux-h8.sourceforge.jp/
S:      Supported

The "/" sneakily defeats searches for "h8300".
