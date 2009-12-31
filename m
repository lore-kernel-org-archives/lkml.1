Return-Path: <linux-kernel-owner+w=401wt.eu-S1752941AbZLaEM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941AbZLaEM7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 23:12:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752646AbZLaEM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 23:12:59 -0500
Received: from smtpauth.net4india.com ([202.71.129.41]:34761 "EHLO
	smtpauth.net4india.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488AbZLaEM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 23:12:58 -0500
Message-ID: <4B3C24BC.3040906@xenontk.org>
Date: Thu, 31 Dec 2009 09:42:44 +0530
From: David John <davidjon@xenontk.org>
Reply-To: davidjon@xenontk.org
User-Agent: Mozilla/5.0 (X11; X; Linux x86_64; rv:1.9.1.5) Gecko/20091209 Thunderbird/3.0
MIME-Version: 1.0
To: airlied@gmail.com
CC: linux-kernel@vger.kernel.org, eric@anholt.net, jbarnes@virtuousgeek.org
Subject: Re: [PATCH] drm: Keep disabled outputs disabled after suspend / resume
References: <1262178636-10778-1-BlackWidow-davidjon@xenontk.org>
In-Reply-To: <1262178636-10778-1-BlackWidow-davidjon@xenontk.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/30/2009 06:40 PM, David John wrote:
> With the current DRM code, an output that has been powered off
> from userspace will automatically power back on when resuming
> from suspend. This patch fixes this behaviour.
> 
> Tested only with the Intel i915 driver on an Intel GM45 Express
> chipset.
> 
> Signed-off-by: David John <davidjon@xenontk.org>

Sorry, this patch is a bit incorrect. I'll send an updated one soon.

Regards,
David.
