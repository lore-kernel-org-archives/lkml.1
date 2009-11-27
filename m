Return-Path: <linux-kernel-owner+w=401wt.eu-S1752395AbZK0Iyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395AbZK0Iyq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 03:54:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751372AbZK0Iyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 03:54:46 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37632 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbZK0Iyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 03:54:45 -0500
Date: Fri, 27 Nov 2009 08:54:17 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@Opfer-Online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
       utx@penguin.cz
Subject: Re: [patch] spitz: better voltage-to-percentage conversion
Message-ID: <20091127085417.GB27009@n2100.arm.linux.org.uk>
References: <20091127073119.GB1405@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091127073119.GB1405@ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 27, 2009 at 08:31:19AM +0100, Pavel Machek wrote:
> +
> +typedef int miliamp_t;
> +typedef int miliohm_t;
> +typedef int milivolt_t;

'milliamp' 'milliohm' 'millivolt'
