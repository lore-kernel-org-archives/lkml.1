Return-Path: <linux-kernel-owner+w=401wt.eu-S1753828AbYASHVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828AbYASHVP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 02:21:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751429AbYASHVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 02:21:04 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:26594 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbYASHVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 02:21:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=L0ojGsCO0B3N/ll/JWoUzaGjKbdwHqipczfUlSq1wUH0mBiGksuspmgQVEh6ENnKD7f5CuLVrrwsXXxwXQkiHTefpxZPVDpg7JR3hEtA0otd+i2HhDiGhW4kxZUDCCgDqxTSyw0Hkc28RkEMkxuSOnjDexpkkHWrsXpfYgLJYrI=
Message-ID: <fa0147d90801182321v31b9a1d3m344ed3c047f74757@mail.gmail.com>
Date: Fri, 18 Jan 2008 23:21:01 -0800
From: Taral <taralx@gmail.com>
To: "Michael Opdenacker" <michael-lists@free-electrons.com>
Subject: Re: [PATCH] x86: fix unconditional arch/x86/kernel/pcspeaker.c compiling
Cc: Linux-tiny@selenic.com, linux-kernel@vger.kernel.org
In-Reply-To: <479061BF.2020801@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200801171643.49301.michael-lists@free-electrons.com>
	 <478F8AEC.1080209@free-electrons.com>
	 <1200590031.5332.19.camel@cinder.waste.org>
	 <200801172315.29976.michael-lists@free-electrons.com>
	 <fa0147d90801171916u2b96bfa0jbeceef57c9c0f641@mail.gmail.com>
	 <479061BF.2020801@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/18/08, Michael Opdenacker <michael-lists@free-electrons.com> wrote:
> Do you mean "almost nothing"? It still allocates and adds a platform
> device, and the corresponding function always gets called at boot time.

Nothing significant then. I don't see any added functionality from this file.

-- 
Taral <taralx@gmail.com>
"Please let me know if there's any further trouble I can give you."
    -- Unknown
