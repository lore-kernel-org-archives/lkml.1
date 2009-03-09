Return-Path: <linux-kernel-owner+w=401wt.eu-S1752449AbZCITeB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449AbZCITeB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 15:34:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751705AbZCITdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 15:33:53 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:44156 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563AbZCITdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 15:33:52 -0400
Message-ID: <49B56F18.1050904@nortel.com>
Date: Mon, 09 Mar 2009 13:33:44 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081209)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: reason for delay in arch/x86/kernel/traps.c::io_check_error()?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Mar 2009 19:33:45.0920 (UTC) FILETIME=[F6731400:01C9A0ED]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi all,

I was just wondering about the basis for the delay in io_check_error(). 
  The ICH7 manual doesn't have any mention of a delay being required 
here--is it necessary for other hardware, something not mentioned in the 
manual, or just an accident?

Thanks,

Chris
