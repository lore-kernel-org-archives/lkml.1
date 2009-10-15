Return-Path: <linux-kernel-owner+w=401wt.eu-S1762998AbZJOTqI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762998AbZJOTqI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 15:46:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760768AbZJOTqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 15:46:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44910 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757918AbZJOTqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 15:46:06 -0400
Date: Thu, 15 Oct 2009 12:45:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>, Nitin Gupta <ngupta@vflare.org>,
       hongshin@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 7/9] swap_info: swap count continuations
Message-Id: <20091015124500.01f7f063.akpm@linux-foundation.org>
In-Reply-To: <20091015123024.21ca3ef7.kamezawa.hiroyu@jp.fujitsu.com>
References: <Pine.LNX.4.64.0910150130001.2250@sister.anvils>
	<Pine.LNX.4.64.0910150153560.3291@sister.anvils>
	<20091015123024.21ca3ef7.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Oct 2009 12:30:24 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> Is  array of "unsigned long" counter is bad ?  (too big?)

metoo!
