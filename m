Return-Path: <linux-kernel-owner+w=401wt.eu-S1754636AbXLKAIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636AbXLKAIu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 19:08:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbXLKAIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 19:08:42 -0500
Received: from smtp3-g19.free.fr ([212.27.42.29]:59315 "EHLO smtp3-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751081AbXLKAIm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 19:08:42 -0500
Date: Tue, 11 Dec 2007 01:01:25 +0100
From: Guillaume Chazarain <guichaz@yahoo.fr>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Stefano Brivio <stefano.brivio@polimi.it>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: 2.6.24-rc4-git5: Reported regressions from 2.6.23
Message-ID: <20071211010125.75e2e807@inria.fr>
In-Reply-To: <20071210155611.512ab381@laptopd505.fenrus.org>
References: <200712080340.49546.rjw@sisk.pl>
	<20071210204212.GA5502@elte.hu>
	<20071210125923.37bd2f10.akpm@linux-foundation.org>
	<20071210224508.GB27178@elte.hu>
	<20071210230425.GA641@elte.hu>
	<20071211003433.5cf0230d@morte>
	<20071210155611.512ab381@laptopd505.fenrus.org>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven <arjan@infradead.org> wrote:

> the frequency of both cores is the maximum of what linux sets each core to;

Do you mean that the cpufreq code can be confused about the actual
frequency of the cores? That sounds like a big problem.

Thanks for any insight.

-- 
Guillaume
