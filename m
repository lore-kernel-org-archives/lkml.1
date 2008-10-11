Return-Path: <linux-kernel-owner+w=401wt.eu-S1758766AbYJKQwN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758766AbYJKQwN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 12:52:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754179AbYJKQv6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 12:51:58 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:33658 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753858AbYJKQv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 12:51:58 -0400
Date: Sat, 11 Oct 2008 18:51:02 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Alex Bennee <kernel-hacker@bennee.com>
Cc: Bruno =?unknown-8bit?Q?Pr=C3=A9mont?= <bonbons@linux-vserver.org>,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: rtl8169_get_stats seems to be adding random crap to
	rx_missed_errors count
Message-ID: <20081011165101.GA18732@electric-eye.fr.zoreil.com>
References: <b2cdc9f30810100947s699dbc76ia72023b08e064816@mail.gmail.com> <b2cdc9f30810100953i680c2d02s8352bb109d494bf1@mail.gmail.com> <20081010232724.1447f915@neptune.home> <b2cdc9f30810102342t5bb07d82m94a4bffab2b68673@mail.gmail.com> <b2cdc9f30810110149k7ca4f331q872a200465a9eb0e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b2cdc9f30810110149k7ca4f331q872a200465a9eb0e@mail.gmail.com>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Bennee <kernel-hacker@bennee.com> :
[...]

The fix is in davem's net-next tree. David has sent a pull request
yesterday so the fix ought to be in 2.6.28.

Thanks for your testing.

-- 
Ueimor
