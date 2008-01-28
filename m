Return-Path: <linux-kernel-owner+w=401wt.eu-S1764168AbYA1WXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764168AbYA1WXA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 17:23:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763405AbYA1WSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 17:18:24 -0500
Received: from main.gmane.org ([80.91.229.2]:45860 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763191AbYA1WSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 17:18:21 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
Subject: Re: chars > 0xa0 not displayed in console since 2.6.24
Date: Mon, 28 Jan 2008 22:18:06 +0000
Message-ID: <yw1xlk694msh.fsf@mansr.com>
References: <479E5082.50208@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: thrashbarg.mansr.com
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (Educational Television, linux)
Cancel-Lock: sha1:yYkLk/moWVOzyEmFx/OquHiqQjQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gerardo Exequiel Pozzi <djgera@gmail.com> writes:

> Hello,
>
> Chars are displayed OK in kernels < 2.6.24 (2.6.22.16, 2.6.23.14) with
> the same config.
> I booted clean with init=/bin/bash to discard distro
> (slackware-current) problem/incompat, but the problem persist.
>
> This is a know problem?

Probably something to do with this commit:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=ecb77fa96ceda9cae88015bfe3293ffe19006159

-- 
Måns Rullgård
mans@mansr.com

