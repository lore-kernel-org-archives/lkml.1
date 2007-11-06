Return-Path: <linux-kernel-owner+w=401wt.eu-S1756786AbXKFVRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786AbXKFVRX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 16:17:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754380AbXKFVRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 16:17:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49974 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338AbXKFVRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 16:17:14 -0500
Message-ID: <4730D8B7.7020909@zytor.com>
Date: Tue, 06 Nov 2007 13:12:23 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [patch 1/4] Create arch/Kconfig
References: <20071106203724.620893371@polymtl.ca> <20071106204151.811746387@polymtl.ca>
In-Reply-To: <20071106204151.811746387@polymtl.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ideally architecture should be a Kconfig option (it's not needed before 
config runs, unlike, say HOSTCC.)

That might take some major surgery, though.

	-hpa
