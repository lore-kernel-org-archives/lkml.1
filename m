Return-Path: <linux-kernel-owner+w=401wt.eu-S1752854AbYLGFDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854AbYLGFDS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 00:03:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750791AbYLGFDD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 00:03:03 -0500
Received: from mailout04.t-online.de ([194.25.134.18]:44022 "EHLO
	mailout04.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695AbYLGFDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 00:03:01 -0500
Message-ID: <493B58FF.3070503@t-online.de>
Date: Sun, 07 Dec 2008 06:02:55 +0100
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
X-ID: E68fUTZBghmDyzLn8NmX-SjIVhKor9+zw-GgMawqtkuuvzaVxJ5MFx5l9dnn5Z+Zch
X-TOI-MSGID: ec661228-7a9f-47ec-9340-7be4a3834021
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jordan Crouse wrote:
> Also, 
> try something in the 2.6.28 family to rule out fixes in the timer 
> subsystem.
> 

Using 2.6.28-rc7 the problem seems to be gone. There was no complain
about TSC in dmesg, and clock speed is OK. (ntp is off.)


Many thanx

Harri

