Return-Path: <linux-kernel-owner+w=401wt.eu-S1758184AbYLFOVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758184AbYLFOVm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 09:21:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756080AbYLFOVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 09:21:33 -0500
Received: from mailout04.t-online.de ([194.25.134.18]:58567 "EHLO
	mailout04.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755575AbYLFOVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 09:21:33 -0500
Message-ID: <493A8A63.2020400@t-online.de>
Date: Sat, 06 Dec 2008 15:21:23 +0100
From: Harald Dunkel <harald.dunkel@t-online.de>
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Jordan Crouse <jordan@cosmicpenguin.net>
CC: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.27.7 built for Geode: Clock drift
References: <49358017.7080009@t-online.de> <493961EE.6000002@cosmicpenguin.net>
In-Reply-To: <493961EE.6000002@cosmicpenguin.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: bd6-ayZ6ohqeeevPxlpM7NkyqwEi7+fe-SyCCY3Puxk1Qh-PfnB760Q8evIStKLZBK
X-TOI-MSGID: c6515bca-577a-4b71-a783-82b65cab5b20
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jordan,

Sorry for the empty reply. I clicked on [Send] by accident.

Jordan Crouse wrote:
> 
> Hmm - we've heard reports of this before, but nothing came of it.  I 
> would be interested in a chance to debug it this time.
> 
> Please try turning off CONFIG_GEODE_MFGPT_TIMER=y and try again.

AFAICS this was already set.

> Also, 
> try something in the 2.6.28 family to rule out fixes in the timer 
> subsystem.
> 

The build is running, but it is a slow machine.


Regards

Harri

