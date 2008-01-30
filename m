Return-Path: <linux-kernel-owner+w=401wt.eu-S933304AbYA3UQI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933304AbYA3UQI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 15:16:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763954AbYA3UDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 15:03:35 -0500
Received: from stinky.trash.net ([213.144.137.162]:60187 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763789AbYA3UDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:03:32 -0500
Message-ID: <47A0D7F1.7010700@trash.net>
Date: Wed, 30 Jan 2008 21:02:57 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071009)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Pavel Emelyanov <xemul@openvz.org>,
       "David S. Miller" <davem@davemloft.net>,
       netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] make nf_ct_path[] static
References: <20080130200259.GE29368@does.not.exist>
In-Reply-To: <20080130200259.GE29368@does.not.exist>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> This patch makes the needlessly global nf_ct_path[] static.


I already have this queued.
