Return-Path: <linux-kernel-owner+w=401wt.eu-S1760803AbXEXIRo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760803AbXEXIRo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 04:17:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756132AbXEXIRa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 04:17:30 -0400
Received: from aa012msr.fastwebnet.it ([85.18.95.72]:58174 "EHLO
	aa012msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756088AbXEXIR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 04:17:28 -0400
Date: Thu, 24 May 2007 10:17:16 +0200
From: Paolo Ornati <ornati@fastwebnet.it>
To: "Antonino Ingargiola" <tritemio@gmail.com>
Cc: "Romano Giannetti" <romano.giannetti@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.21.1 fails to suspend/resume to disk (sort of)
Message-ID: <20070524101716.1e11f329@localhost>
In-Reply-To: <5486cca80705240101u2fb6a954q53025752560f3ef7@mail.gmail.com>
References: <1179905115.7043.25.camel@localhost>
	<200705231105.08408.rjw@sisk.pl>
	<1179914262.7043.56.camel@localhost>
	<5486cca80705240101u2fb6a954q53025752560f3ef7@mail.gmail.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 May 2007 10:01:21 +0200
"Antonino Ingargiola" <tritemio@gmail.com> wrote:

> Is not the ubuntu or debian way to take hours to compile. Is that you
> have to trim the config and enable the only modules you need for your
> hardware, then a rebuild cycle could last 10-15 min.

Even 3-5 min if you strip it down a lot and with good hardware :)

Also ccache helps.

-- 
	Paolo Ornati
	Linux 2.6.22-rc2-gd2579053 on x86_64
