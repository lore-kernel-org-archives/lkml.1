Return-Path: <linux-kernel-owner+w=401wt.eu-S1755517AbYHHA3J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517AbYHHA3J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 20:29:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754179AbYHHA2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 20:28:44 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:37780 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838AbYHHA2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 20:28:43 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <489B9334.1060202@s5r6.in-berlin.de>
Date: Fri, 08 Aug 2008 02:28:36 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.16) Gecko/20080722 SeaMonkey/1.1.11
MIME-Version: 1.0
To: jmerkey@wolfmountaingroup.com
CC: Andi Kleen <andi@firstfloor.org>,
       Jason Wessel <jason.wessel@windriver.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Merkey's Kernel Debugger
References: <17494.166.70.238.46.1217784156.squirrel@webmail.wolfmountaingroup.com>    <Pine.LNX.4.64.0808051140150.6309@anakin>    <33030.166.70.238.45.1217948565.squirrel@webmail.wolfmountaingroup.com>    <200808060133.10457.nickpiggin@yahoo.com.au>    <87r6926dsr.fsf@basil.nowhere.org> <4899DD9F.6020007@windriver.com>    <20080806185719.GE24801@one.firstfloor.org> <37747.166.70.238.45.1218113134.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <37747.166.70.238.45.1218113134.squirrel@webmail.wolfmountaingroup.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jmerkey@wolfmountaingroup.com wrote:
> It would be nice if checkpatch also could FIX those areas it complains about.

scripts/Lindent can at least help with some of the whitespace changes. 
It's long ago though that I used it myself, so I have no idea how well 
that works.
-- 
Stefan Richter
-=====-==--- =--- -=---
http://arcgraph.de/sr/
