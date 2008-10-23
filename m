Return-Path: <linux-kernel-owner+w=401wt.eu-S1754875AbYJWGRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875AbYJWGRZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 02:17:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbYJWGRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 02:17:17 -0400
Received: from mo-p05-ob.rzone.de ([81.169.146.181]:48929 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbYJWGRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 02:17:16 -0400
X-RZG-CLASS-ID: mo05
X-RZG-AUTH: :Pm0FVUW6aauhRGJJc5OfA4AU8DM8ZlijdmJYxKn/UQvEQQx8Ak89p3I=
Date: Thu, 23 Oct 2008 08:17:12 +0200
From: Alex Riesen <fork0@users.sourceforge.net>
To: Markus Rechberger <mrechberger@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       em28xx@mcentral.de
Subject: Re: [PATCH] em28xx patches against the latest git tree
Message-ID: <20081023061712.GA4596@blimp.localdomain>
Reply-To: Alex Riesen <fork0@users.sourceforge.net>
References: <d9def9db0810221034v3bf4dabt6aa905b8a3ebd5a@mail.gmail.com> <d9def9db0810221038g156871e1u200abb90b774ad28@mail.gmail.com> <81b0412b0810221059w2e02b1c1ubd894b22f7991242@mail.gmail.com> <d9def9db0810221110g6f104b17g36a74704d43c5693@mail.gmail.com> <20081022182924.GA4626@blimp.localdomain> <20081022184058.GB4626@blimp.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081022184058.GB4626@blimp.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Riesen, Wed, Oct 22, 2008 20:40:58 +0200:
> 
> BTW, you forgot to a patch to include your driver into Kconfig of
> drivers/media/video. ...
> 

And the upper-level Makefile. Otherwise the driver wasn't even
compiled. It has some warnings regarding unused inc_ref/dec_ref, BTW

