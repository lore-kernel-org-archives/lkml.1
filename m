Return-Path: <linux-kernel-owner+w=401wt.eu-S1762475AbYETXfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762475AbYETXfd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 19:35:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752896AbYETXfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 19:35:25 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58250 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041AbYETXfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 19:35:24 -0400
Message-ID: <48336039.3010308@firstfloor.org>
Date: Wed, 21 May 2008 01:35:21 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: corbet@lwn.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [2/11] Add unlocked_fasync
References: <20080520528.793382059@firstfloor.org>	<20080520152843.CF4181B4205@basil.firstfloor.org>	<20080520085830.22c99115@infradead.org>	<483318AE.2090306@firstfloor.org> <20080520130624.089ebf19@infradead.org>
In-Reply-To: <20080520130624.089ebf19@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> My concern is that the new API as long lived is ugly and not the right
> thing. I assume Linus and others have similar concerns, and weigh that
> over the "some obscure out of tree driver might break".

What do you find ugly exactly? The prefix "unlocked_" ? Other than
that there is no difference.

Duplicated entry points are not great, but they will be going away.

-Andi


