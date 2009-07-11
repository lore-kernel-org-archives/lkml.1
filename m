Return-Path: <linux-kernel-owner+w=401wt.eu-S1755459AbZGKHot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459AbZGKHot (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 03:44:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752061AbZGKHoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 03:44:16 -0400
Received: from one.firstfloor.org ([213.235.205.2]:56721 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbZGKHoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 03:44:14 -0400
From: Andi Kleen <andi@firstfloor.org>
Message-Id: <20090711944.448667020@firstfloor.org>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [0/3] x86: mce: A few more minor cleanups for the x86 mce code
Date: Sat, 11 Jul 2009 09:44:08 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Some more cleanups, following up the previous mce cleanup series.
This doesn't change any code behaviour, just tidies up the code
a bit.

This applies on top of the previous cleanup series.

-Andi

