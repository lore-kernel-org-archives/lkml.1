Return-Path: <linux-kernel-owner+w=401wt.eu-S1759460AbZCQF6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759460AbZCQF6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 01:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752450AbZCQF6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 01:58:06 -0400
Received: from ozlabs.org ([203.10.76.45]:53672 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751667AbZCQF6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 01:58:05 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Valdis.Kletnieks@vt.edu
Subject: Re: linux-next - request_module_nowait() breaks iptables and iwl3945
Date: Tue, 17 Mar 2009 16:27:58 +1030
User-Agent: KMail/1.11.1 (Linux/2.6.27-11-generic; KDE/4.2.1; i686; ; )
Cc: Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org
References: <3823.1237168684@turing-police.cc.vt.edu>
In-Reply-To: <3823.1237168684@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903171627.58963.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 March 2009 12:28:04 Valdis.Kletnieks@vt.edu wrote:
> On recent linux-next, iptables and iwl3945 would fail to load

Please send .config; I can't reproduce this here.

Thanks,
Rusty.
