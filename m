Return-Path: <linux-kernel-owner+w=401wt.eu-S1754129AbYLHWkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129AbYLHWkd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 17:40:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753212AbYLHWkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 17:40:24 -0500
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:41173 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753174AbYLHWkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 17:40:23 -0500
Date: Mon, 8 Dec 2008 23:40:23 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Shaya Potter <spotter@yucs.org>
Cc: Giangiacomo Mariotti <giangiacomo.mariotti@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: weird realtek gigabit ethernet issue
Message-ID: <20081208224023.GA8492@electric-eye.fr.zoreil.com>
References: <493CB716.8070300@yucs.org> <2aac3c260812072334v5d85ca2cke6cd33d7c912b8ea@mail.gmail.com> <493D360D.5030203@yucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <493D360D.5030203@yucs.org>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shaya Potter <spotter@yucs.org> :
[...]
> perhaps, it also show me no dropped packets, but that would indicate a
> bug in /proc/net/dev.

It is unrelated.

It should be fixed in mainline as 523a609496dbc3897e530db2a2f27650d125ea00
and in 2.6.27-stable as 6269b8494da80250422ed8ce4e6ee7126c0010aa.

-- 
Ueimor
