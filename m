Return-Path: <linux-kernel-owner+w=401wt.eu-S1756491AbYGVNSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756491AbYGVNSh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 09:18:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753573AbYGVNS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 09:18:28 -0400
Received: from styx.suse.cz ([82.119.242.94]:34105 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751234AbYGVNS1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 09:18:27 -0400
Date: Tue, 22 Jul 2008 15:18:26 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Henrik Rydberg <rydberg@euromail.se>
cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, robfitz@273k.net,
       akpm@osdl.org, Vojtech Pavlik <vojtech@suse.cz>, dmonakhov@openvz.org
Subject: Re: [PATCH] hid: apple_fn_keys F5 and F6
In-Reply-To: <1215965784.20146.0.camel@alnilam>
Message-ID: <alpine.LNX.1.10.0807221514300.3037@jikos.suse.cz>
References: <1215965784.20146.0.camel@alnilam>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Jul 2008, Henrik Rydberg wrote:

> This patch maps the F5 and F6 keys to KBDILLUMDOWN and KBDILLUMUP, 
> respektively, which make them work as keyboard backlight control keys.

Applied, thanks a lot Henrik.

-- 
Jiri Kosina
SUSE Labs
