Return-Path: <linux-kernel-owner+w=401wt.eu-S1757219AbYLaVfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757219AbYLaVfn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 16:35:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752866AbYLaVff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 16:35:35 -0500
Received: from mx2.redhat.com ([66.187.237.31]:37422 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719AbYLaVfe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 16:35:34 -0500
Message-ID: <495BE59C.5040803@redhat.com>
Date: Wed, 31 Dec 2008 16:35:24 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Peter W Morreale <pmorreale@novell.com>
CC: akpm@linux-foundation.org, andi@firstfloor.org,
       linux-kernel@vger.kernel.org, spamtrap@knobisoft.de
Subject: Re: [PATCH 2/2] Add /proc controls for pdflush threads
References: <20081231190755.30792.24205.stgit@hermosa.site> <20081231191013.30792.64706.stgit@hermosa.site>
In-Reply-To: <20081231191013.30792.64706.stgit@hermosa.site>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter W Morreale wrote:
> This patch adds /proc entries to give the admin the ability to
> control the minimum and maximum number of pdflush threads.  This allows
> finer control of pdflush on both large and small machines.

> Signed-off-by: Peter W Morreale <pmorreale@novell.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
