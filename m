Return-Path: <linux-kernel-owner+w=401wt.eu-S1756823AbZJCSTL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823AbZJCSTL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 14:19:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756785AbZJCSTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 14:19:10 -0400
Received: from vbn.0050556.lodgenet.net ([216.142.194.234]:34367 "EHLO
	vbn.0050556.lodgenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257AbZJCSTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 14:19:10 -0400
Subject: Re: [PATCH] drivers/video/backlight: memset region size error
From: Richard Purdie <rpurdie@rpsys.net>
To: Jan Ceuleers <jan.ceuleers@computer.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4AC76178.8090302@computer.org>
References: <4AC76178.8090302@computer.org>
Content-Type: text/plain
Date: Sat, 03 Oct 2009 18:00:07 +0100
Message-Id: <1254589207.19472.3.camel@ted>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-10-03 at 16:36 +0200, Jan Ceuleers wrote:
> From 61755f56b829f59a40f9d30799651f80a3554104 Mon Sep 17 00:00:00 2001
> From: Jan Ceuleers <jan.ceuleers@computer.org>
> Date: Sat, 3 Oct 2009 16:00:36 +0200
> Subject: [PATCH] drivers/video/backlight: memset region size error
> 
> The size of the region to be memset() should be the size
> of the target rather than the size of the pointer to it.
> 
> Compile-tested only.
> 
> Signed-off-by: Jan Ceuleers <jan.ceuleers@computer.org>

The same patch was posted yesterday by Jean Delvare and I've queued that
but thanks!

Cheers,

Richard
-- 
Richard Purdie
Intel Open Source Technology Centre

