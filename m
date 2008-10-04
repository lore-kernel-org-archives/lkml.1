Return-Path: <linux-kernel-owner+w=401wt.eu-S1753282AbYJDKUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282AbYJDKUU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 06:20:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752199AbYJDKUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 06:20:07 -0400
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:44365 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697AbYJDKUG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 06:20:06 -0400
Date: 04 Oct 2008 12:20:02 +0200
From: krzysztof.h1@poczta.fm
Subject: Re: [PATCH -mm] fb: fix NULL pointer BUG dereference in fb_open()
To: "righi.andrea@gmail.com" <righi.andrea@gmail.com>,
       Krzysztof Helt <krzysztof.h1@poczta.fm>,
       Andrew Morton <akpm@linux-foundation.org>,
       "adaplas@gmail.com" <adaplas@gmail.com>
Cc: "linux-fbdev-devel@lists.sourceforge.net" 
	<linux-fbdev-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: TEXT/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-ORIGINATE-IP: 89.151.20.32
X-Mailer: PSE
Message-Id: <20081004102002.36184141A442@f15.poczta.interia.pl>
X-EMID: 9ac40acc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Accessing to an unregistered fb device raises the following bug, because
> mutex_unlock() is called on fb_info->lock, but fb_info is NULL.
> 
> Also use a better coding style.
> 

Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>

----------------------------------------------------------------------
Dzwon taniej na zagraniczne komorki!
Sprawdz >> http://link.interia.pl/f1f26 

