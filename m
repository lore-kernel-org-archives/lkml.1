Return-Path: <linux-kernel-owner+w=401wt.eu-S1751955AbYLUSkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955AbYLUSkt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 13:40:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751118AbYLUSkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 13:40:39 -0500
Received: from twin.jikos.cz ([213.151.79.26]:51573 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068AbYLUSki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 13:40:38 -0500
Date: Sun, 21 Dec 2008 19:39:52 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Jiri Kosina <jkosina@suse.cz>
cc: Parag Warudkar <parag.lkml@gmail.com>,
       Anssi Hannula <anssi.hannula@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: 2.6.28-rc9: USB Mouse unhappy
In-Reply-To: <alpine.LRH.1.10.0812211824350.11630@twin.jikos.cz>
Message-ID: <alpine.LRH.1.10.0812211939170.11630@twin.jikos.cz>
References: <f7848160812201911k7988221asd095ce873fd8105f@mail.gmail.com>  <20081220221253.e09b1b1f.akpm@linux-foundation.org>  <f7848160812202226w1f930c86vfd17a2b0163bfc56@mail.gmail.com>  <494E20F7.7050106@gmail.com> <f7848160812210717w5e5cc7a2uc5571710f755ec99@mail.gmail.com>
 <alpine.LRH.1.10.0812211824350.11630@twin.jikos.cz>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Dec 2008, Jiri Kosina wrote:

>   usbmouse on 2.6.28-rc with the exact same mouse? (either check 
>   /sys/bus/usb/devices or even lsusb shouldn't ideally show usbmouse 
>   loaded at all)

Sorry for the above typo, 'lsusb' should of course be 'lsmod' here.

-- 
Jiri Kosina
SUSE Labs

