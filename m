Return-Path: <linux-kernel-owner+w=401wt.eu-S1758392AbYDNNkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758392AbYDNNkp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 09:40:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752541AbYDNNki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 09:40:38 -0400
Received: from de01egw01.freescale.net ([192.88.165.102]:55541 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492AbYDNNkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 09:40:37 -0400
Message-ID: <48035E93.6070300@freescale.com>
Date: Mon, 14 Apr 2008 08:39:31 -0500
From: Timur Tabi <timur@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.11) Gecko/20071128 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jiri Slaby <jirislaby@gmail.com>, York Sun <yorksun@freescale.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       galak@kernel.crashing.org
Subject: Re: [PATCH 1/2] Driver for Freescale 8610 and 5121 DIU
References: <12053582234100-git-send-email-yorksun@freescale.com>	<12053582231281-git-send-email-yorksun@freescale.com>	<47D8572C.8090501@gmail.com>	<47FFDBFF.1030809@gmail.com> <20080411221817.0b1eb414.akpm@linux-foundation.org>
In-Reply-To: <20080411221817.0b1eb414.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:

> Thanks.  I've made a note that this patch has outstanding issues.  Usually
> this means that I'll defer merging it until they have been addressed:
> either by fixing them or by successfully arguing against the objections.  

Sorry, I must have gotten out of sync.  What are the outstanding issues?  I was
under the impression that the latest patch (v5) resolved everything.  In fact,
the last email from you (dated 4/1) said that you picked it up, minus the defconfig.

-- 
Timur Tabi
Linux kernel developer at Freescale
