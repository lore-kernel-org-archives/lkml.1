Return-Path: <linux-kernel-owner+w=401wt.eu-S1752804AbYHLVkP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804AbYHLVkP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 17:40:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751199AbYHLVkB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 17:40:01 -0400
Received: from senator.holtmann.net ([87.106.208.187]:34916 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbYHLVkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 17:40:00 -0400
Subject: Re: CRDA and uevent
From: Marcel Holtmann <marcel@holtmann.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <43e72e890808111804j6ecd66c9r9907523d7f7594ed@mail.gmail.com>
References: <43e72e890808051812y1f6b18ecpac089e45d4c18b84@mail.gmail.com>
	 <43e72e890808111804j6ecd66c9r9907523d7f7594ed@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 12 Aug 2008 23:40:07 +0200
Message-Id: <1218577207.25524.42.camel@californication>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Luis,

> > Marcel I know you also mentioned about using device platform for this?
> > Is this correct or did I misunderstand? Can you elaborate a bit?
> 
> OK I got this to work, will send patches soon.

good, because I was running quite busy on my side. You could use a class
like the firmware loader does btw.

Regards

Marcel


