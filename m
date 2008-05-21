Return-Path: <linux-kernel-owner+w=401wt.eu-S1762502AbYEUJBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762502AbYEUJBf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 05:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757456AbYEUJB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 05:01:26 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:59314 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754334AbYEUJBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 05:01:24 -0400
X-Sasl-enc: dZq920+wqJhAA63MUh7cU+WCM8i2ZuXPfM8+J4QeAZmT 1211360483
Message-ID: <4833E4E4.6050505@ladisch.de>
Date: Wed, 21 May 2008 11:01:24 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: corbet@lwn.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [9/11] Convert hpet to unlocked_fasync
References: <20080520528.793382059@firstfloor.org> <20080520152851.002131B4203@basil.firstfloor.org>
In-Reply-To: <20080520152851.002131B4203@basil.firstfloor.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Just calls fasync_helper and private structure is protected by
> file reference count.
>
> Cc: clemens@ladisch.de
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

Acked-by: Clemens Ladisch <clemens@ladisch.de>
