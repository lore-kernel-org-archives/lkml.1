Return-Path: <linux-kernel-owner+w=401wt.eu-S1751450AbZIPESM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751450AbZIPESM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 00:18:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751234AbZIPESL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 00:18:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59624 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751045AbZIPESL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 00:18:11 -0400
Date: Tue, 15 Sep 2009 21:18:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: 2.6.32 -mm Blackfin patches
Message-Id: <20090915211810.d1b83015.akpm@linux-foundation.org>
In-Reply-To: <8bd0f97a0909152056h61bfc487g6b8631966c6d72be@mail.gmail.com>
References: <8bd0f97a0909152056h61bfc487g6b8631966c6d72be@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Sep 2009 23:56:21 -0400 Mike Frysinger <vapier.adi@gmail.com> wrote:

> On Tue, Sep 15, 2009 at 19:15, Andrew Morton wrote:
> > blackfin-convert-to-use-arch_gettimeoffset.patch
> 
> i thought John was merging this via some sort of patch series, but i
> can pick it up in the Blackfin tree to make sure things are really
> sane

Sent.

> > blackfin-fix-read-buffer-overflow.patch
> 
> the latter patch i merged into my tree (and i thought that i followed
> up in the original posting about this)

Well, it isn't in linux-next so as far as I'm concerned I have the
only copy.  Should you be getting your tree into linux-next?

