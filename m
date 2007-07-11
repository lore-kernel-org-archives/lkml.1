Return-Path: <linux-kernel-owner+w=401wt.eu-S1764491AbXGKMrB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764491AbXGKMrB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 08:47:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764336AbXGKMqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 08:46:50 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48678 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764327AbXGKMqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 08:46:49 -0400
Date: Wed, 11 Jul 2007 14:46:47 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Segher Boessenkool <segher@kernel.crashing.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jan Engelhardt <jengelh@computergmbh.de>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       andi@firstfloor.org, akpm@linux-foundation.org
Subject: Re: [x86 setup 16/33] String-handling functions for the new x86 setup code.
Message-ID: <20070711124647.GB18767@one.firstfloor.org>
References: <11840371953778-git-send-email-hpa@zytor.com> <11840373002601-git-send-email-hpa@zytor.com> <11840374052662-git-send-email-hpa@zytor.com> <1184037510289-git-send-email-hpa@zytor.com> <11840376162370-git-send-email-hpa@zytor.com> <Pine.LNX.4.64.0707102022400.11053@fbirervta.pbzchgretzou.qr> <4693D183.9060604@zytor.com> <298A54C9-B331-4AB9-98B3-5C815B04381E@kernel.crashing.org> <4693EFBF.4070605@zytor.com> <C65610C3-64A5-476D-8371-1338FA8F7D0E@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C65610C3-64A5-476D-8371-1338FA8F7D0E@kernel.crashing.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes, Linux should definitely be compiled with -ffreestanding,
> it isn't a hosted application after all ;-)

We tried it some time ago and it caused problems so it was dropped
again

-Andi
