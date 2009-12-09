Return-Path: <linux-kernel-owner+w=401wt.eu-S1756232AbZLIQlC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232AbZLIQlC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 11:41:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756172AbZLIQlB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 11:41:01 -0500
Received: from khc.piap.pl ([195.187.100.11]:42190 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756162AbZLIQlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 11:41:00 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Rudy Matela <rudy.matela@gmail.com>
Cc: Jan Yenya Kasprzak <kas@fi.muni.cz>, trivial@kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] Coding style correction on some drivers that use Generic HDLC
References: <20091209143540.GA9620@vacuum.larces.uece.br>
Date: Wed, 09 Dec 2009 17:41:04 +0100
In-Reply-To: <20091209143540.GA9620@vacuum.larces.uece.br> (Rudy Matela's
	message of "Wed, 9 Dec 2009 11:35:40 -0300")
Message-ID: <m33a3k9k2n.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rudy Matela <rudy.matela@gmail.com> writes:

> Added a space separating some if/switch/while keywords from the following
> parenthesis to conform to the CodingStyle.
>
> Signed-off-by: Rudy Matela <rudy.matela@gmail.com>
> ---
>
>  drivers/net/wan/cosa.c       |   10 +++++-----
>  drivers/net/wan/hdlc_cisco.c |    8 ++++----
>  drivers/net/wan/hdlc_x25.c   |    4 ++--

Ack from me, though a subset may already be in David Miller's tree.
Git merge can handle it without problems I guess.

Who is to commit this?
-- 
Krzysztof Halasa
