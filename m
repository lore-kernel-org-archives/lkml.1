Return-Path: <linux-kernel-owner+w=401wt.eu-S1754074AbZEDVsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074AbZEDVsl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 17:48:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752104AbZEDVsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 17:48:32 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:53805 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830AbZEDVsc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 17:48:32 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0905031305130.18426@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0905031305130.18426@chino.kir.corp.google.com>
Date: Mon, 4 May 2009 14:48:32 -0700
Message-ID: <d6200be20905041448p1ca2d068r5ba8348488842b5c@mail.gmail.com>
Subject: Re: [patch 1/5] oom: cleanup android low memory killer
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       San Mehat <san@android.com>, linux-kernel@vger.kernel.org,
       Greg KH <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 4, 2009 at 9:35 AM, David Rientjes <rientjes@google.com> wrote:
> Clean up the code in lowmem_shrink() for the Android low memory killer so
> that it follows the kernel coding style.
>

Do you mind applying the lowmemorykiller patches from the
android-2.6.29 branch in
git://android.git.kernel.org/kernel/common.git first. It already has
some of this clean up.

-- 
Arve Hjønnevåg
