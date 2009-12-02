Return-Path: <linux-kernel-owner+w=401wt.eu-S1751210AbZLBFXL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751210AbZLBFXL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 00:23:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750927AbZLBFXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 00:23:10 -0500
Received: from smtpauth.net4india.com ([202.71.129.41]:42893 "EHLO
	smtpauth.net4india.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbZLBFXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 00:23:10 -0500
Message-ID: <4B15FA04.2020206@xenontk.org>
Date: Wed, 02 Dec 2009 10:54:20 +0530
From: David John <davidjon@xenontk.org>
Reply-To: davidjon@xenontk.org
User-Agent: Mozilla/5.0 (X11; X; Linux x86_64; rv:1.9.1.4pre) Gecko/20091014 Thunderbird/3.0b4
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jonathan Miles <jon@cybus.co.uk>, penberg@cs.helsinki.fi
Subject: Re: OOM kernel behaviour
References: <alpine.DEB.2.00.0912011007360.8841@router.home> <4B154E10.7050300@xenontk.org> <20091202132026.5C55.A69D9226@jp.fujitsu.com>
In-Reply-To: <20091202132026.5C55.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2009 09:59 AM, KOSAKI Motohiro wrote:
> Proprietary module is loaded.

That's the Broadcom wireless wl driver. It isn't causing the problem.

> 
> Probably, some program in your system leaked memory.
> 

Is there some way to find out? I tried to analyse top and ps output
but there isn't anything that stands out.

Regards,
David.
