Return-Path: <linux-kernel-owner+w=401wt.eu-S1753171AbYAIAx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171AbYAIAx7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 19:53:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752789AbYAIAxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 19:53:49 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:2936 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbYAIAxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 19:53:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=QumRM4wzKXnPdcXPnG1FW2An7svEbnAke5BgBdPx2japvFes6ZC/SkutSnNMyCRWcZ3RadSJ90O8UWCJC6pYVHrs0ys5JLRLmIdfhq1MZLymqWnQMoXEfvXV2DU45BdYsxogSLHocYfmagtKnchUPpnggThPIwrhHte0FN3JhXE=
Subject: Re: [PATCH] x86: Introduce __die helper to X86_32
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1199839688.6424.17.camel@brick>
References: <1199839688.6424.17.camel@brick>
Content-Type: text/plain
Date: Tue, 08 Jan 2008 16:53:49 -0800
Message-Id: <1199840029.6424.21.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-01-08 at 16:48 -0800, Harvey Harrison wrote:
> Small step towards unifying traps_32|64.c.  No functional
> changes.  Pull out a small helper from an if() statement
> in die().
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
> Ingo, I know this will have checkpatch problems, doing code
> movement first, will do the cleanup as a final step once
> we get to the end of unifying the files.
> 

Sorry, sent the wrong version, will not compile.  Will follow up.

Harvey

