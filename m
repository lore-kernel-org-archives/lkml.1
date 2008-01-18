Return-Path: <linux-kernel-owner+w=401wt.eu-S1762747AbYARWrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762747AbYARWrf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 17:47:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932166AbYARWrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 17:47:24 -0500
Received: from gw.goop.org ([64.81.55.164]:36189 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759738AbYARWrX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 17:47:23 -0500
Message-ID: <47912C77.5090909@goop.org>
Date: Fri, 18 Jan 2008 14:47:19 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       glommer@gmail.com, tglx@linutronix.de, mingo@elte.hu,
       ehabkost@redhat.com, avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       ak@suse.de, chrisw@sous-sol.org, rostedt@goodmis.org, hpa@zytor.com,
       zach@vmware.com, roland@redhat.com, mtosatti@redhat.com
Subject: Re: [PATCH 9/10] provide __parainstructions section
References: <12006768251548-git-send-email-gcosta@redhat.com> <12006768362108-git-send-email-gcosta@redhat.com> <1200676842822-git-send-email-gcosta@redhat.com> <12006768473571-git-send-email-gcosta@redhat.com> <12006768521391-git-send-email-gcosta@redhat.com> <1200676857691-git-send-email-gcosta@redhat.com> <12006768631010-git-send-email-gcosta@redhat.com> <12006768683247-git-send-email-gcosta@redhat.com> <12006768732175-git-send-email-gcosta@redhat.com> <12006768793416-git-send-email-gcosta@redhat.com> <20080118204125.GA20904@uranus.ravnborg.org>
In-Reply-To: <20080118204125.GA20904@uranus.ravnborg.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> Are we going to see this for other archs than just x86?
> If so then please add this to include/asm-generic/vmlinux.lds.h
>   

In theory other architectures could use a similar mechanism, but for now 
its x86 specific.

    J
