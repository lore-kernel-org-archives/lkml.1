Return-Path: <linux-kernel-owner+w=401wt.eu-S1757243AbZAMVbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243AbZAMVbU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 16:31:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752780AbZAMVbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 16:31:10 -0500
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:4251 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620AbZAMVbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 16:31:09 -0500
Message-ID: <496D081B.1070202@xs4all.nl>
Date: Tue, 13 Jan 2009 22:31:07 +0100
From: Hans de Bruin <bruinjm@xs4all.nl>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Kernelmessage to usbstick?
References: <4968F346.8060806@xs4all.nl>
In-Reply-To: <4968F346.8060806@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hans de Bruin wrote:
> Would it be possible to send kernel messages to an usbstick? On poweroff 
> my laptop displays a kernel trace and a final message:
> poweroff[3114] exited with preempt_count 2
> /etc/rc.d/rc.0: line 265: 3114 Segementation fault /sbin/poweroff.
> I don't have a serial cable within reach, but plenty of usbsticks.
> 

The shutdown problem just disappeared.

-- 
Hans
