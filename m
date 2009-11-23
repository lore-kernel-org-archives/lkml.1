Return-Path: <linux-kernel-owner+w=401wt.eu-S1754811AbZKWCkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811AbZKWCkn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 21:40:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753854AbZKWCkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 21:40:43 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46333 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753460AbZKWCkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 21:40:42 -0500
Date: Sun, 22 Nov 2009 18:40:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Jan Beulich" <JBeulich@novell.com>
Cc: <sam@ravnborg.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] genksyms: properly consider
 EXPORT_UNUSED_SYMBOL{,_GPL}()
Message-Id: <20091122184041.8ed496a7.akpm@linux-foundation.org>
In-Reply-To: <4B06AD4302000078000211E3@vpn.id2.novell.com>
References: <4B06AD4302000078000211E3@vpn.id2.novell.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Nov 2009 13:52:51 +0000 "Jan Beulich" <JBeulich@novell.com> wrote:

> Despite being unused these should also get a CRC calculated.

why?
