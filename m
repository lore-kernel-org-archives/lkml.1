Return-Path: <linux-kernel-owner+w=401wt.eu-S932249AbXBSNnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932249AbXBSNnw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 08:43:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932251AbXBSNnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 08:43:52 -0500
Received: from mail.station1.mxsweep.com ([212.147.136.149]:2993 "EHLO
	SCMF01.mxsweep.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932249AbXBSNnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 08:43:51 -0500
Message-ID: <45D9A91D.9090707@draigBrady.com>
Date: Mon, 19 Feb 2007 13:41:49 +0000
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
User-Agent: Thunderbird 1.5.0.8 (X11/20061116)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Phy Prabab <phyprabab@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Question about setting affinity in 2.4
References: <2fe399760702181802q39e75b42iea7f80124506f169@mail.gmail.com> <1171891986.3531.34.camel@laptopd505.fenrus.org>
In-Reply-To: <1171891986.3531.34.camel@laptopd505.fenrus.org>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Mlf-Version: 5.0.2.8415
X-Mlf-UniqueId: o200702191345290225537
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> sched_setaffinity takes 3 not 2 parameters.

Yep the interface changed 3 times, hence
it's probably better using the syscall directly.
Search my notes for sched_setaffinity here:
http://www.pixelbeat.org/programming/c_c++_notes.html

Pádraig.
