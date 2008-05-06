Return-Path: <linux-kernel-owner+w=401wt.eu-S1760783AbYEFMfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760783AbYEFMfY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 08:35:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754133AbYEFMfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 08:35:07 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:36045 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754067AbYEFMfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 08:35:06 -0400
Date: Tue, 6 May 2008 14:35:05 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: bad pmd ffff810000207808(9090909090909090).
In-Reply-To: <874p9biqwj.fsf@duaron.myhome.or.jp>
Message-ID: <alpine.LNX.1.10.0805061424090.16731@fbirervta.pbzchgretzou.qr>
References: <874p9biqwj.fsf@duaron.myhome.or.jp>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tuesday 2008-05-06 14:00, OGAWA Hirofumi wrote:

>Hi,
>
>I've found today the following error in syslog. It seems have a strange
>pattern. And it also happened at a month ago.
>
>Any idea for debuging this?
>

90 is NOP on x86, perhaps something got rooted?
