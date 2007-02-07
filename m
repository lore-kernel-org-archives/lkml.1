Return-Path: <linux-kernel-owner+w=401wt.eu-S1161396AbXBGRd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161396AbXBGRd3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 12:33:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161397AbXBGRd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 12:33:29 -0500
Received: from aa012msr.fastwebnet.it ([85.18.95.72]:36256 "EHLO
	aa012msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161396AbXBGRd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 12:33:28 -0500
Date: Wed, 7 Feb 2007 18:33:19 +0100
From: Paolo Ornati <ornati@fastwebnet.it>
To: "Trevor Offner Caira" <toc3@cornell.edu>
Cc: linux-kernel@vger.kernel.org, "Tejun Heo" <htejun@gmail.com>
Subject: Re: PROBLEM: sata timeouts with intel 82801HB on amd64
Message-ID: <20070207183319.74aadfc7@localhost>
In-Reply-To: <32895.74.71.32.29.1170853186.squirrel@webmail.cornell.edu>
References: <34171.74.71.32.29.1170727713.squirrel@webmail.cornell.edu>
	<20070207094105.7ab1c601@localhost>
	<32895.74.71.32.29.1170853186.squirrel@webmail.cornell.edu>
X-Mailer: Sylpheed-Claws 2.4.0 (GTK+ 2.10.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Feb 2007 07:59:46 -0500 (EST)
"Trevor Offner Caira" <toc3@cornell.edu> wrote:

> > 1) disabling NCQ ("echo 1 > /sys/block/sda/device/queue_depth" in a
> > boot script)
> 
> No, this does not fix it.
> 
> > 	OR
> >
> > 2) mounting XFS filesystem(s) with "nobarrier" option
> 
> Neither does this.

ok, so it's a different problem (I've tried :)

-- 
	Paolo Ornati
	Linux 2.6.20 on x86_64
