Return-Path: <linux-kernel-owner+w=401wt.eu-S1754447AbYGCQK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447AbYGCQK3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 12:10:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752639AbYGCQKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 12:10:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56732 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752294AbYGCQKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 12:10:21 -0400
Message-ID: <486CF9B9.2090002@linux-foundation.org>
Date: Thu, 03 Jul 2008 11:09:29 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Matt Mackall <mpm@selenic.com>, Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: slub: Do not use 192 byte sized cache if minimum alignment is
 128 byte
References: <486CDEC2.5030803@linux-foundation.org> <84144f020807030837k213e1880vf2d01bcf77e6886c@mail.gmail.com>
In-Reply-To: <84144f020807030837k213e1880vf2d01bcf77e6886c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think this needs to go into .26.

