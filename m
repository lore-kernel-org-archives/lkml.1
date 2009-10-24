Return-Path: <linux-kernel-owner+w=401wt.eu-S1752862AbZJXJO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862AbZJXJO3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Oct 2009 05:14:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751886AbZJXJO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Oct 2009 05:14:28 -0400
Received: from mailout07.t-online.de ([194.25.134.83]:38258 "EHLO
	mailout07.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003AbZJXJO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Oct 2009 05:14:28 -0400
Message-ID: <4AE2C572.1030209@t-online.de>
Date: Sat, 24 Oct 2009 11:14:26 +0200
From: Harald Dunkel <harald.dunkel@t-online.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090923 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.31.4, ps2-to-usb adapter: fourth mouse button not working
References: <1N1EA3-10pOoy0@fwd05.aul.t-online.de> <20091023073730.GB10914@srcf.ucam.org>
In-Reply-To: <20091023073730.GB10914@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: ZZ2LYgZpZhvBDReTDIGkHwgiuPNvCBK2DESRwzUy-lUd7v8GQ7o6ZZZ2zvFx4i6ZEA
X-TOI-MSGID: e1e7b5e0-6066-4198-b0c1-9aae1e979349
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/09 09:37, Matthew Garrett wrote:
> Sorry, just noticed that you said it was an active one. Does it generate
> wheel events for any other PS/2 mice? It may simply be a limitation of
> the hardware.
>

Using a regular mouse with 3 buttons and a wheel there is no problem.
All work fine. But it just got 3 buttons. I've got problems with a
fourth button, so the PS/2 mouse doesn't show.

Is there a hardwired limit to 3 buttons somewhere in the code?


Regards

Harri
