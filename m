Return-Path: <linux-kernel-owner+w=401wt.eu-S1762623AbXIZWBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762623AbXIZWBR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 18:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758436AbXIZWBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 18:01:05 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:40664 "EHLO
	fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757066AbXIZWBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 18:01:04 -0400
Date: Wed, 26 Sep 2007 23:57:38 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Timo Jantunen <jeti@welho.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: commit 6dccd16b7c2703e8bbf8bca62b5cf248332afbe2 kills r8169 send performance
Message-ID: <20070926215738.GA6443@electric-eye.fr.zoreil.com>
References: <Pine.LNX.4.64.0709261853110.5869@limbo> <20070926170718.GA4870@electric-eye.fr.zoreil.com> <Pine.LNX.4.64.0709262137440.5856@limbo>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="ikeVEW9yuYc//A+q"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709262137440.5856@limbo>
User-Agent: Mutt/1.4.2.1i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Timo Jantunen <jeti@welho.com> :
[...]
> Thanks for the quick reply and fix. Unfortunately the fix didn't help in my 
> case.

Apply and try each patch of the attached tarball on top of 2.6.23-git
until the behavior changes (assuming it does).

Patch #000n applies on top of patch #000(n - 1).

Good night.

-- 
Ueimor

--ikeVEW9yuYc//A+q
Content-Type: application/x-gzip
Content-Disposition: attachment; filename="r8169-timo-20070926.tgz"
Content-Transfer-Encoding: base64

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
UEMNNdRQQw011FBDDTXU0Cfpv3YA/OQAUAAA

--ikeVEW9yuYc//A+q--
