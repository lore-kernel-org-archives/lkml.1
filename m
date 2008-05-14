Return-Path: <linux-kernel-owner+w=401wt.eu-S1760307AbYENMIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760307AbYENMIi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 08:08:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757999AbYENMIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 08:08:30 -0400
Received: from styx.suse.cz ([82.119.242.94]:57388 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757468AbYENMIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 08:08:30 -0400
Date: Wed, 14 May 2008 14:08:28 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jiri Slaby <jirislaby@gmail.com>
cc: Marcel Holtmann <marcel@holtmann.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       anssi.hannula@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH 3/9] HID: hid, make parsing event driven
In-Reply-To: <482AB23C.2090809@gmail.com>
Message-ID: <Pine.LNX.4.64.0805141407050.11363@jikos.suse.cz>
References: <1210536043-19812-1-git-send-email-jirislaby@gmail.com> 
 <1210536043-19812-2-git-send-email-jirislaby@gmail.com> 
 <1210536043-19812-3-git-send-email-jirislaby@gmail.com>
 <1210548050.16390.39.camel@violet.holtmann.net> <482AB23C.2090809@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2008, Jiri Slaby wrote:

> Not really. I was only to test non-hid path (i.e. input) of hidp 
> changes. This is why I want it in -mm/-next for some time. If you have 
> some (real) bluetooth HID devices, I would be glad if you could test it.

Hi,

I will of course test the patches (including testing with bluetooth HID 
hardware) before merging them.

Thanks,

-- 
Jiri Kosina
SUSE Labs
