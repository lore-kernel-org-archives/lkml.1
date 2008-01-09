Return-Path: <linux-kernel-owner+w=401wt.eu-S1755404AbYAIEm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404AbYAIEm0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 23:42:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752929AbYAIEmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 23:42:17 -0500
Received: from [212.12.190.53] ([212.12.190.53]:34893 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752847AbYAIEmQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 23:42:16 -0500
X-Greylist: delayed 26332 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Jan 2008 23:42:15 EST
From: Al Boldi <a1426z@gawab.com>
To: Rik van Riel <riel@redhat.com>
Subject: Re: [RFD] Incremental fsck
Date: Wed, 9 Jan 2008 07:40:12 +0300
User-Agent: KMail/1.5
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200801090022.55589.a1426z@gawab.com> <20080108164106.735c431d@bree.surriel.com>
In-Reply-To: <20080108164106.735c431d@bree.surriel.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200801090740.12989.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote:
> Al Boldi <a1426z@gawab.com> wrote:
> > Has there been some thought about an incremental fsck?
> >
> > You know, somehow fencing a sub-dir to do an online fsck?
>
> Search for "chunkfs"

Sure, and there is TileFS too.

But why wouldn't it be possible to do this on the current fs infrastructure, 
using just a smart fsck, working incrementally on some sub-dir?


Thanks!

--
Al

