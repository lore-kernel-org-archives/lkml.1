Return-Path: <linux-kernel-owner+w=401wt.eu-S1764646AbYESWit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764646AbYESWit (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 18:38:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756020AbYESWik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 18:38:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48529 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756676AbYESWij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 18:38:39 -0400
Date: Mon, 19 May 2008 15:32:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org, Steven French <sfrench@us.ibm.com>
Subject: Re: [2.6.27 patch] the scheduled smbfs removal
Message-Id: <20080519153249.ea80e683.akpm@linux-foundation.org>
In-Reply-To: <20080519215311.GE17716@cs181133002.pp.htv.fi>
References: <20080519215311.GE17716@cs181133002.pp.htv.fi>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 May 2008 00:53:11 +0300
Adrian Bunk <bunk@kernel.org> wrote:

> This patch contains the scheduled smbfs removal.

I don't know how popular this will be right now - quite a few
people needed to be dragged over to cifs up to a month or two
ago.

I'd suggest that we first use CONFIG_BROKEN or
CONFIG_DIFFICULT_TO_GET_AT and see what the effect of that is.

