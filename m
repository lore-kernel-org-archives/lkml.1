Return-Path: <linux-kernel-owner+w=401wt.eu-S1756352Ab0AGHyK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756352Ab0AGHyK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 02:54:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756203Ab0AGHyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 02:54:09 -0500
Received: from smtpauth.net4india.com ([202.71.129.41]:60358 "EHLO
	smtpauth.net4india.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756134Ab0AGHyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 02:54:08 -0500
Message-ID: <4B45931E.3000902@xenontk.org>
Date: Thu, 07 Jan 2010 13:24:06 +0530
From: David John <davidjon@xenontk.org>
Reply-To: davidjon@xenontk.org
User-Agent: Mozilla/5.0 (X11; X; Linux x86_64; rv:1.9.1.5) Gecko/20091209 Thunderbird/3.0
MIME-Version: 1.0
To: airlied@gmail.com
CC: linux-kernel@vger.kernel.org, eric@anholt.net, jbarnes@virtuousgeek.org,
       dri-devel@lists.sourceforge.net
Subject: Re: [PATCH v2] drm: Keep disabled outputs disabled after suspend
 / resume
References: <4B3C24BC.3040906@xenontk.org> <1262241046-3740-1-BlackWidow-davidjon@xenontk.org>
In-Reply-To: <1262241046-3740-1-BlackWidow-davidjon@xenontk.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/31/2009 12:00 PM, David John wrote:
> With the current DRM code, an output that has been powered off
> from userspace will automatically power back on when resuming
> from suspend. This patch fixes this behaviour.
> 
> Tested only with the Intel i915 driver on an Intel GM45 Express
> chipset.
> 
> Signed-off-by: David John <davidjon@xenontk.org>

Ping.

Any update on this? Correct? Incorrect? Utter rubbish that I should be
ashamed of myself?

Regards,
David.
