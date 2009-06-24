Return-Path: <linux-kernel-owner+w=401wt.eu-S1754614AbZFXWlF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614AbZFXWlF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 18:41:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752249AbZFXWkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 18:40:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35968 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751577AbZFXWky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 18:40:54 -0400
Date: Wed, 24 Jun 2009 15:40:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: linux-ext4@vger.kernel.org, bdonlan@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ext[234]: Return -EIO not -ESTALE on directory
 traversal
Message-Id: <20090624154025.285e108c.akpm@linux-foundation.org>
In-Reply-To: <4A425F8B.2000907@gmail.com>
References: <4A425F8B.2000907@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Jun 2009 19:16:59 +0200
Karl Beldan <karl.beldan@gmail.com> wrote:

> Hi,
> 
> e6f009b for ext4,
> de18f3b for ext3.
> 
> It seems that ext2 didn't get it.
> 

hm, well spotted.  I seem to have fumbled that patch.  I'll send it in
for 2.6.31.

