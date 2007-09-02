Return-Path: <linux-kernel-owner+w=401wt.eu-S964908AbXIBG76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964908AbXIBG76 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 02:59:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933787AbXIBG7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 02:59:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40853 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842AbXIBG7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 02:59:43 -0400
Message-ID: <46DA5F33.2020005@zytor.com>
Date: Sun, 02 Sep 2007 07:58:59 +0100
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Junio C Hamano <gitster@pobox.com>
CC: git@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] GIT 1.5.3
References: <7vodglr32i.fsf@gitster.siamese.dyndns.org>
In-Reply-To: <7vodglr32i.fsf@gitster.siamese.dyndns.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Junio C Hamano wrote:
> 
> * For people who need to import from Perforce, a front-end for
>   fast-import is in contrib/fast-import/.
> 

There seems to be an issue with this and RPMS.

In particular, there is no longer a git-p4 RPMS, which prevents git from 
getting upgraded at all by yum.

Anyone who knows yum well enough to explain what needs to be done so 
that yum knows this is obsolete?

	-hpa

