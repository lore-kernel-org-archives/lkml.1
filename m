Return-Path: <linux-kernel-owner+w=401wt.eu-S1756611AbYHGSPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611AbYHGSPd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 14:15:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753128AbYHGSPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 14:15:18 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:59350 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988AbYHGSPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 14:15:17 -0400
Message-ID: <17167.166.70.238.44.1218131635.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <489B34BA.4060300@linux-foundation.org>
References: <17494.166.70.238.46.1217784156.squirrel@webmail.wolfmountaingroup.com>
    <200808060133.10457.nickpiggin@yahoo.com.au>
    <87r6926dsr.fsf@basil.nowhere.org>
    <200808061550.22996.nickpiggin@yahoo.com.au>
    <489B34BA.4060300@linux-foundation.org>
Date: Thu, 7 Aug 2008 11:53:55 -0600 (MDT)
Subject: Re: [ANNOUNCE] Merkey's Kernel Debugger
From: jmerkey@wolfmountaingroup.com
To: "Christoph Lameter" <cl@linux-foundation.org>
Cc: "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Andi Kleen" <andi@firstfloor.org>, jmerkey@wolfmountaingroup.com,
       "Geert Uytterhoeven" <geert@linux-m68k.org>,
       "Stefan Richter" <stefanr@s5r6.in-berlin.de>,
       "Josh Boyer" <jwboyer@gmail.com>, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Nick Piggin wrote:
>
>> OK thanks for the info. I don't actually know debugger code as I
>> said, so I wasn't against merging mdb if it offers things that
>> kgdb fundamentally cannot.
>>
>> If so, then ensuring clean interfaces indeed would seem like a
>> good first step to getting it merged.
>
> The competing implementation is kdb not kgdb. kgdb is just a stub for
> remote
> debugging using gdb. kdb is an in-kernel debugger like the one proposed
> here.
>

I don't consider them competing, just different tools for people from
different development backgrounds.  GNU and DOS/Windows.

Jeff

