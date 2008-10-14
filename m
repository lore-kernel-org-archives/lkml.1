Return-Path: <linux-kernel-owner+w=401wt.eu-S1754508AbYJNUYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508AbYJNUYS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 16:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752975AbYJNUYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 16:24:04 -0400
Received: from styx.suse.cz ([82.119.242.94]:44385 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752850AbYJNUYC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 16:24:02 -0400
Date: Tue, 14 Oct 2008 22:24:01 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
cc: LKML <linux-kernel@vger.kernel.org>,
       Douglas Landgraf <dougsland@gmail.com>,
       Alexey Klimov <klimov.linux@gmail.com>
Subject: Re: [PATCH 3/3] Don't let Avermedia Radio FM800 be detected as a
 normal HID device
In-Reply-To: <20081014111023.04c8a059@pedra.chehab.org>
Message-ID: <alpine.LNX.1.10.0810142222330.26779@jikos.suse.cz>
References: <20081014111023.04c8a059@pedra.chehab.org>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Oct 2008, Mauro Carvalho Chehab wrote:

> Based on an original patch from Alexey Klimov <klimov.linux@gmail.com>,
> against kernel version 2.6.27.

Hi Mauro,

this is a rather short changelog ... what is the reason here? I guess 
there is a proper driver for this device somewhere in drivers/video, 
right?

Thanks,

-- 
Jiri Kosina
SUSE Labs
