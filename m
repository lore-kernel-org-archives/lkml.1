Return-Path: <linux-kernel-owner+w=401wt.eu-S1762627AbYG1VU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762627AbYG1VU7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 17:20:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761409AbYG1VRz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 17:17:55 -0400
Received: from gw.goop.org ([64.81.55.164]:51437 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761430AbYG1VRx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 17:17:53 -0400
Message-ID: <488E377E.6060808@goop.org>
Date: Mon, 28 Jul 2008 14:17:50 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH 0/24] x86: arch/x86/kernel/ cleanups
References: <gustavo@las.ic.unicamp.br> <1217279371-4410-1-git-send-email-gustavo@las.ic.unicamp.br>
In-Reply-To: <1217279371-4410-1-git-send-email-gustavo@las.ic.unicamp.br>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gustavo F. Padovan wrote:
> Ingo,
>
>
> Ingo,
>
> I removed many extra whitespaces and tabs from arch/x86/kernel/
>   

This is not a good time to be posting this kind of patch.  These kinds 
of trivial cleanups are best done in a late -rc, when the patch rate 
goes down.  However, pure whitespace cleanups  have very little value 
like this, particularly since it looks like you're breaking the 
formatting in some cases.

It would be better to address them in passing if there's some more 
substantial change which needs to be done to the code.  
http://janitor.kernelnewbies.org/ should be a good place to look for 
suggestions.

    J
