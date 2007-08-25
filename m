Return-Path: <linux-kernel-owner+w=401wt.eu-S1764667AbXHYM6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764667AbXHYM6A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 08:58:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751677AbXHYM5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 08:57:52 -0400
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3384 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbXHYM5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 08:57:51 -0400
Message-ID: <46D0272D.4010800@xs4all.nl>
Date: Sat, 25 Aug 2007 14:57:17 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Adrian Bunk <bunk@kernel.org>, mpm@selenic.com, mb@bu3sch.de
Subject: Re: possible BUG while doing gpg --gen-key
References: <46CF079C.7010304@xs4all.nl> <20070825011419.GL30705@stusta.de> <46CFCA78.2090500@xs4all.nl>
In-Reply-To: <46CFCA78.2090500@xs4all.nl>
X-Enigmail-Version: 0.95.3
OpenPGP: id=8300CC02
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Udo van den Heuvel wrote:
> Now it works:

Stranger even:

With audio-entropyd, rngd active and the netdev-random patch working I
cannot reproduce the crash. Even after a fresh boot.
