Return-Path: <linux-kernel-owner+w=401wt.eu-S1754552AbYHROIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552AbYHROIR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 10:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752800AbYHROH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 10:07:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50086 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752530AbYHROH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 10:07:58 -0400
Message-ID: <48A98228.9090006@linux-foundation.org>
Date: Mon, 18 Aug 2008 09:07:36 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
CC: =?ISO-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
       David Miller <davem@davemloft.net>, Netdev <netdev@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: tbench regression on each kernel release from 2.6.22 -> 2.6.28
References: <48A086B6.2000901@linux-foundation.org>	 <20080811.141501.01468546.davem@davemloft.net>	 <Pine.LNX.4.64.0808121058550.4551@wrl-59.cs.helsinki.fi> <1219025114.25933.6.camel@ymzhang>
In-Reply-To: <1219025114.25933.6.camel@ymzhang>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zhang, Yanmin wrote:

> Other regressions on other machines are similar.

There are AIM7 regressions that are similar to tbench.

2.6.22	28436
2.6.26	23064
