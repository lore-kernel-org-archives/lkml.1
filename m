Return-Path: <linux-kernel-owner+w=401wt.eu-S1752574AbXLEAv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574AbXLEAv1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 19:51:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751004AbXLEAvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 19:51:19 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:47581 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751079AbXLEAvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 19:51:19 -0500
Date: Wed, 5 Dec 2007 00:46:39 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Brett T. Warden" <brett.warden@gmail.com>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
       "Brett T. Warden" <brett.warden@gmail.com>
Subject: Re: [PATCH] bw-qcam: Adds module parameter 'aggressive' to skip
 polite auto-detection prior to direct initialization.
Message-ID: <20071205004639.3a5cc948@the-village.bc.nu>
In-Reply-To: <11968154813878-git-send-email->
References: <11968154813878-git-send-email->
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  4 Dec 2007 16:44:41 -0800
"Brett T. Warden" <brett.warden@gmail.com> wrote:

> Setting aggressive=1 bypasses the friendly auto-detection by polling the status register, and instead attempts to initialize the qcam directly. Not friendly to other parallel devices, but much more reliable than the auto-detection.

Someone still has a bw-qcam device ?

The status polling ought to be rock solid - what values do you see ?
