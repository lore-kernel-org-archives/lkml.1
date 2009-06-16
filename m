Return-Path: <linux-kernel-owner+w=401wt.eu-S1761677AbZFPSk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761677AbZFPSk5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 14:40:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756411AbZFPSkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 14:40:49 -0400
Received: from stz-softwaretechnik.de ([217.160.223.211]:4882 "EHLO
	stlx01.stz-softwaretechnik.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751023AbZFPSks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 14:40:48 -0400
Date: Tue, 16 Jun 2009 20:40:27 +0200
From: Ralf Gross <Ralf-Lists@ralfgross.de>
To: linux-kernel@vger.kernel.org
Subject: Re: io-scheduler tuning for better read/write ratio
Message-ID: <20090616184027.GB7043@p15145560.pureserver.info>
References: <20090616154342.GA7043@p15145560.pureserver.info> <4A37CB2A.6010209@davidnewall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A37CB2A.6010209@davidnewall.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Newall schrieb:
> Ralf Gross wrote:
> > write throughput is much higher than the read throughput (40 MB/s
> > read, 90 MB/s write).

Hm, but I get higher read throughput (160-200 MB/s) if I don't write
to the device at the same time.

Ralf
