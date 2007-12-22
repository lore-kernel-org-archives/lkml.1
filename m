Return-Path: <linux-kernel-owner+w=401wt.eu-S1753289AbXLVIan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289AbXLVIan (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 03:30:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750936AbXLVIaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 03:30:35 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47173 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750859AbXLVIae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 03:30:34 -0500
Date: Sat, 22 Dec 2007 00:30:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Clemens Koller <clemens.koller@anagramm.de>,
       Mikael Starvik <mikael.starvik@axis.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove unused __dummy, CONST_ADDR and ADDR from CRIS
 bitops.h
Message-Id: <20071222003025.148ea0ad.akpm@linux-foundation.org>
In-Reply-To: <20071220100944.GG10888@axis.com>
References: <20071220100944.GG10888@axis.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Dec 2007 11:09:44 +0100 Jesper Nilsson <jesper.nilsson@axis.com> wrote:

> Subject: [PATCH] Remove unused __dummy, CONST_ADDR and ADDR from CRIS bitops.h

It's nice (and conventional) to prefix the patch title with the subsystem
name.  So this one would become


Subject: [PATCH] cris: remove unused __dummy, CONST_ADDR and ADDR from bitops.h

Thanks.
