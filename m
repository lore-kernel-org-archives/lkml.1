Return-Path: <linux-kernel-owner+w=401wt.eu-S1754923AbXGaIIH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923AbXGaIIH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 04:08:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752100AbXGaIHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 04:07:48 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57853 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751964AbXGaIHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 04:07:46 -0400
Date: Tue, 31 Jul 2007 09:14:25 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Eugene Teo <eugeneteo@kernel.sg>
Cc: linux-kernel@vger.kernel.org,
       "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>,
       Neil Horman <nhorman@tuxdriver.com>, Bryan Wu <bryan.wu@analog.com>
Subject: Re: [PATCH 2/3] coredump: remove suidsafe mode related dead code
Message-ID: <20070731091425.04fb865b@the-village.bc.nu>
In-Reply-To: <20070731070458.GC2412@kernel.sg>
References: <20070731070238.GA2412@kernel.sg>
	<20070731070458.GC2412@kernel.sg>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jul 2007 15:04:58 +0800
Eugene Teo <eugeneteo@kernel.sg> wrote:

> This patch removes suidsafe core dump mode related dead code.
> 
> Signed-off-by: Eugene Teo <eugeneteo@kernel.sg>

NAK: This feature is used by end users and people debugging complex
system problems.
