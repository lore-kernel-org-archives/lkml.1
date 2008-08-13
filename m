Return-Path: <linux-kernel-owner+w=401wt.eu-S1756922AbYHMSCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922AbYHMSCT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 14:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753191AbYHMSCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 14:02:10 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:38529 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622AbYHMSCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 14:02:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ZvVEi5AVmJrnEi/YYZFXpHXJV3oL213f9on7SPOFTd2ok7Wuk3uRfYGY0u1/Cx/3kA
         l5zGMFGma3U4mwVILspF42kQCQ7YcUoP2asLKurVujEN/duVUWtVZrnqLABS8ZOQJUwq
         tlEGzS7MLJvEJ6952EojSGdGjk+kiWu0mQ7b0=
Message-ID: <eada2a070808131102p1ede7addg6aaec342182a7738@mail.gmail.com>
Date: Wed, 13 Aug 2008 11:02:08 -0700
From: "Tim Pepper" <tpepper@gmail.com>
To: "=?ISO-8859-1?Q?Toralf_F=F6rster?=" <toralf.foerster@gmx.de>
Subject: Re: build issue #554 for v2.6.27-rc3 :undefined reference to `lockdep_count_forward_deps'
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200808131618.11819.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200808131618.11819.toralf.foerster@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

See thread: [RFC][PATCH 1/7] lockdep: Fix combinatorial explosion in
lock subgraph traversal.  Andrew's picked up the fix and Ingo has it
in his urgent queue.


Tim
