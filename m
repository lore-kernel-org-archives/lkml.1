Return-Path: <linux-kernel-owner+w=401wt.eu-S1757420AbYJPTSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420AbYJPTSV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 15:18:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756468AbYJPTSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 15:18:11 -0400
Received: from ftp.linux-mips.org ([213.58.128.207]:48898 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756361AbYJPTSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 15:18:10 -0400
Date: Thu, 16 Oct 2008 20:18:04 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Hans Schou <linux@schou.dk>
cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SiS55x, another x86 CPU
In-Reply-To: <Pine.LNX.4.64.0810162050150.7314@sko.w0.dk>
Message-ID: <alpine.LFD.1.10.0810162014590.21444@ftp.linux-mips.org>
References: <Pine.LNX.4.64.0810111143210.23344@sko.w0.dk> <87d4i5rq7i.fsf@basil.nowhere.org> <Pine.LNX.4.64.0810132240010.8901@sko.w0.dk> <20081014060616.GO12131@one.firstfloor.org> <Pine.LNX.4.64.0810140828220.11184@sko.w0.dk> <20081015100637.GS12131@one.firstfloor.org>
 <Pine.LNX.4.64.0810152150070.25933@anakin> <Pine.LNX.4.64.0810160027150.7873@sko.w0.dk> <Pine.LNX.4.64.0810160907330.25933@anakin> <Pine.LNX.4.64.0810162050150.7314@sko.w0.dk>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Oct 2008, Hans Schou wrote:

> > But, why do you send patches as attachments in the first place?
> 
> Ingo said I could do so when it was something to do with x86 patches.
> Anyway, it looks like ^R in Pine did work correctly.

 You've got:

Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed

in your headers -- it may be good for poetry, but will guarantee you 
breakage with inline patches.  There's an option to disable it.

  Maciej
