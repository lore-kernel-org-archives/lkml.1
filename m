Return-Path: <linux-kernel-owner+w=401wt.eu-S1754776AbYGVIzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbYGVIzo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 04:55:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752784AbYGVIzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 04:55:22 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:44258 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560AbYGVIzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 04:55:20 -0400
Date: Tue, 22 Jul 2008 10:55:18 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Tim Gardner <tim.gardner@canonical.com>
cc: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 1/7] netfilter: Export ip6t_mh.h and xt_quota.h for
 iptables build
In-Reply-To: <E1KKl4I-00068B-LW@swissweb.swissdisk.com>
Message-ID: <alpine.LNX.1.10.0807221054430.23410@fbirervta.pbzchgretzou.qr>
References: <E1KKl4I-00068B-LW@swissweb.swissdisk.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wednesday 2008-01-02 16:57, Tim Gardner wrote:

>Export ip6t_mh.h and xt_quota.h for        
>          iptables build
>
>CC: netfilter-devel@vger.kernel.org
>Signed-off-by: Soren Hansen <soren@ubuntu.com>
>Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
>Signed-off-by: Ben Collins <ben.lcollins@canonical.com>


They are not needed for iptables, which has its own copy of
the headers.
