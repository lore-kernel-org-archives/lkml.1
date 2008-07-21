Return-Path: <linux-kernel-owner+w=401wt.eu-S1754477AbYGUNI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477AbYGUNI5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 09:08:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751692AbYGUNIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 09:08:45 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:46007 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847AbYGUNIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 09:08:44 -0400
Date: Mon, 21 Jul 2008 15:08:43 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Adrian Bunk <bunk@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: asm-x86/processor-flags.h, CONFIG_* leaks
Message-ID: <20080721130843.GA28640@aepfle.de>
References: <20080721124656.GA28618@aepfle.de> <20080721130635.GA19123@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080721130635.GA19123@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, Vegard Nossum wrote:

> why doesn't make headers_check catch it?

An automated grep -r CONFIG_ in the export dir is missing.
