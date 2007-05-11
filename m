Return-Path: <linux-kernel-owner+w=401wt.eu-S1762890AbXEKSfE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762890AbXEKSfE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 14:35:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758519AbXEKSe4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 14:34:56 -0400
Received: from smtp.nokia.com ([131.228.20.173]:19667 "EHLO
	mgw-ext14.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758126AbXEKSez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 14:34:55 -0400
Message-ID: <4644B722.3040607@yandex.ru>
Date: Fri, 11 May 2007 21:34:10 +0300
From: Artem Bityutskiy <dedekind@yandex.ru>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: Remove SLAB_CTOR_CONSTRUCTOR
References: <Pine.LNX.4.64.0705111105180.22949@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0705111105180.22949@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 11 May 2007 18:34:10.0963 (UTC) FILETIME=[F7AAEE30:01C793FA]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> While we are at it: Fix bug in mtd/ubi/eba.c. Check was inverted.
Oh, thanks.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
