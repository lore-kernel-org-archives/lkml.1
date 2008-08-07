Return-Path: <linux-kernel-owner+w=401wt.eu-S1754298AbYHGSIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298AbYHGSIg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 14:08:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752237AbYHGSI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 14:08:28 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:35170 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918AbYHGSI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 14:08:27 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <489B3A0D.7060706@s5r6.in-berlin.de>
Date: Thu, 07 Aug 2008 20:08:13 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.16) Gecko/20080722 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <andi@firstfloor.org>,
       jmerkey@wolfmountaingroup.com,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Merkey's Kernel Debugger
References: <17494.166.70.238.46.1217784156.squirrel@webmail.wolfmountaingroup.com> <200808060133.10457.nickpiggin@yahoo.com.au> <87r6926dsr.fsf@basil.nowhere.org> <200808061550.22996.nickpiggin@yahoo.com.au> <489B34BA.4060300@linux-foundation.org>
In-Reply-To: <489B34BA.4060300@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> The competing implementation is kdb not kgdb. kgdb is just a stub for remote
> debugging using gdb. kdb is an in-kernel debugger like the one proposed here.

Is there work underway to get kdb merged?  (I'm just asking because I 
don't know; I personally don't need kdb nor mdb.)
-- 
Stefan Richter
-=====-==--- =--- --===
http://arcgraph.de/sr/
