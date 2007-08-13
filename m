Return-Path: <linux-kernel-owner+w=401wt.eu-S941679AbXHMTTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941679AbXHMTTV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 15:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758254AbXHMTS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 15:18:56 -0400
Received: from smtprelay12.ispgateway.de ([80.67.29.29]:44316 "EHLO
	smtprelay12.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755359AbXHMTSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 15:18:55 -0400
From: Ingo Oeser <ioe-lkml@rameria.de>
To: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH]: proc: export a processes resource limits via proc/<pid>
Date: Mon, 13 Aug 2007 21:25:45 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
References: <20070813140044.GB1960@hmsreliant.think-freely.org>
In-Reply-To: <20070813140044.GB1960@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708132125.47188.ioe-lkml@rameria.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Neil,

> +static struct limit_names lnames[RLIM_NLIMITS] = {
static const ...

may be better here.

Best Regards

Ingo Oeser
