Return-Path: <linux-kernel-owner+w=401wt.eu-S1760720AbYHEQFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760720AbYHEQFw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 12:05:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756521AbYHEQFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 12:05:43 -0400
Received: from zcars04f.nortel.com ([47.129.242.57]:40228 "EHLO
	zcars04f.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756620AbYHEQFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 12:05:42 -0400
Message-ID: <48987A24.3060000@nortel.com>
Date: Tue, 05 Aug 2008 10:04:52 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: jmerkey@wolfmountaingroup.com
CC: Nick Piggin <nickpiggin@yahoo.com.au>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Merkey's Kernel Debugger
References: <17494.166.70.238.46.1217784156.squirrel@webmail.wolfmountaingroup.com> <Pine.LNX.4.64.0808051140150.6309@anakin> <33030.166.70.238.45.1217948565.squirrel@webmail.wolfmountaingroup.com> <200808060133.10457.nickpiggin@yahoo.com.au> <44919.166.70.238.45.1217949560.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <44919.166.70.238.45.1217949560.squirrel@webmail.wolfmountaingroup.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Aug 2008 16:04:56.0366 (UTC) FILETIME=[0106DCE0:01C8F715]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jmerkey@wolfmountaingroup.com wrote:

> If you go back to LKML from 2000, this debugger has been around for 10
> years.  I agree not in the hands of the public, but its very mature
> in comparison to kdb or kgdb.

Without public use, it's difficult to determine that there aren't any 
nasty interactions.

If you want to maximize your chances of getting this code into the 
kernel, you might want to read Jonathan Corbet's post, "[PATCH] A 
development process document, V2".  It discusses the normal process, how 
to prepare patches for submission, etc.

Chris
