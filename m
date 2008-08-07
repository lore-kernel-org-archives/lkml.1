Return-Path: <linux-kernel-owner+w=401wt.eu-S1753924AbYHGTMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924AbYHGTMT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 15:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751245AbYHGTMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 15:12:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42779 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751001AbYHGTMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 15:12:08 -0400
Message-ID: <489B48BF.3060609@linux-foundation.org>
Date: Thu, 07 Aug 2008 14:10:55 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <andi@firstfloor.org>,
       jmerkey@wolfmountaingroup.com,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org,
       jlan@sgi.com
Subject: Re: [ANNOUNCE] Merkey's Kernel Debugger
References: <17494.166.70.238.46.1217784156.squirrel@webmail.wolfmountaingroup.com> <200808060133.10457.nickpiggin@yahoo.com.au> <87r6926dsr.fsf@basil.nowhere.org> <200808061550.22996.nickpiggin@yahoo.com.au> <489B34BA.4060300@linux-foundation.org> <489B3A0D.7060706@s5r6.in-berlin.de>
In-Reply-To: <489B3A0D.7060706@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> Christoph Lameter wrote:
>> The competing implementation is kdb not kgdb. kgdb is just a stub for
>> remote
>> debugging using gdb. kdb is an in-kernel debugger like the one
>> proposed here.
> 
> Is there work underway to get kdb merged?  (I'm just asking because I
> don't know; I personally don't need kdb nor mdb.)

KDB still exists in patches but the merge effort was given up when Linus
stated that he did not want a kernel debugger. No problem to start merge
attempts again AFAICT. Jay?

