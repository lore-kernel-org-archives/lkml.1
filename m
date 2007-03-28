Return-Path: <linux-kernel-owner+w=401wt.eu-S965714AbXC1TJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965714AbXC1TJu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 15:09:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965692AbXC1TJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 15:09:38 -0400
Received: from styx.suse.cz ([82.119.242.94]:52392 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965707AbXC1TJP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 15:09:15 -0400
Date: Wed, 28 Mar 2007 21:13:58 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Li Yu <liyu@ccoss.com.cn>, yanghong@ccoss.com.cn,
       linux-usb-devel <linux-usb-devel@lists.sourceforge.net>,
       hongzhiyi@ccoss.com.cn, Marcel Holtmann <marcel@holtmann.org>,
       LKML <linux-kernel@vger.kernel.org>, Li Yu <raise.sail@gmail.com>
Subject: Re: [linux-usb-devel] [RFC] HID bus design overview.
In-Reply-To: <d120d5000703281200wd914f51s18437a6a8e4107f6@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0703282113070.19566@jikos.suse.cz>
References: <200703051532096508636@gmail.com> <45FE6971.6090503@gmail.com> 
 <1174897676.5815.6.camel@violet> <4609CAF2.3040303@ccoss.com.cn> 
 <Pine.LNX.4.64.0703280945560.19566@jikos.suse.cz>
 <d120d5000703281200wd914f51s18437a6a8e4107f6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Mar 2007, Dmitry Torokhov wrote:

> Just register based on VID/PID and provide standard 
> hid_default_input_event() to drivers so they would call it for reports 
> they don't need to do special processing on.

Agreed. This is actually what I meant in the original mail, but phrased it 
very badly, sorry for confusion.

Thanks,

-- 
Jiri Kosina
