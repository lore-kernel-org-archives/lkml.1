Return-Path: <linux-kernel-owner+w=401wt.eu-S1423128AbXBBOUO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423128AbXBBOUO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 09:20:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423134AbXBBOUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 09:20:14 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:47512 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423128AbXBBOUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 09:20:13 -0500
Subject: Re: Slower CPU frequency reported by the kernel
From: Arjan van de Ven <arjan@infradead.org>
To: Francis Moreau <francis.moro@gmail.com>
Cc: Paolo Ornati <ornati@fastwebnet.it>, linux-kernel@vger.kernel.org
In-Reply-To: <38b2ab8a0702020603h480fc1dfm22267089341cbe0e@mail.gmail.com>
References: <38b2ab8a0702020311o54789ef6xff819dc3b492b005@mail.gmail.com>
	 <20070202130408.05212b10@localhost>
	 <38b2ab8a0702020603h480fc1dfm22267089341cbe0e@mail.gmail.com>
Content-Type: text/plain
Organization: Intel International BV
Date: Fri, 02 Feb 2007 15:20:10 +0100
Message-Id: <1170426010.3073.932.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-2.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> it's seems that the cpu freq scaling depends on a user space tool.
> Could you tell me how I can find if there're such tools installed on
> my computer ?

it may be userspace, or you may be using the "ondemand" governer. If you
have the userspace tool it's often called "cpuspeed", but it depends on
your distro.

-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

