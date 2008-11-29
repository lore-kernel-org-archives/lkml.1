Return-Path: <linux-kernel-owner+w=401wt.eu-S1755781AbYK2Aub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755781AbYK2Aub (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 19:50:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753176AbYK2AuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 19:50:16 -0500
Received: from casper.infradead.org ([85.118.1.10]:57769 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876AbYK2AuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 19:50:15 -0500
Date: Fri, 28 Nov 2008 16:51:20 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Greg KH <gregkh@suse.de>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: option: oops on unload (2.6.27.4)
Message-ID: <20081128165120.4d587db0@infradead.org>
In-Reply-To: <20081128235010.GB27130@suse.de>
References: <20081128213254.GB6750@joi>
	<20081128215021.GA25391@suse.de>
	<20081128220142.GC6750@joi>
	<20081128235010.GB27130@suse.de>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Nov 2008 15:50:10 -0800
Greg KH <gregkh@suse.de> wrote:
> > > > i2c_core sr_mod evdev dcdbas cdrom [last unloaded: uhci_hcd]

... last unloaded was uhci_hcd ;)

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
