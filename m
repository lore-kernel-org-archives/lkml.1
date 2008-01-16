Return-Path: <linux-kernel-owner+w=401wt.eu-S1758207AbYAPWkB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758207AbYAPWkB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 17:40:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752826AbYAPWjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 17:39:20 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:31868 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbYAPWjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 17:39:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=G0Z9/gGpvL1UneHAUfh7MvlqdsMKjPx3+NpRa2HeYLYam+LDTtAYIHcrgY30jg0mGSZ7JMI+QdJnheuL7kaycM7PtMV3B1OTY9f0iy9hj87FmuLSnZfiYSmXTurRQQV8cEZaJ8sd8yCYaXfx1koDKHq8q0PPFbi0sonF33TxqkQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: bbpetkov@yahoo.de
Subject: Re: (was: Re:...) [PATCH 12/12] ide-floppy: fix most of the remaining checkpatch.pl issues-v2
Date: Wed, 16 Jan 2008 23:51:29 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1200255505-31418-4-git-send-email-bbpetkov@yahoo.de> <1200255505-31418-13-git-send-email-bbpetkov@yahoo.de> <20080115201251.GC5699@gollum.tnic>
In-Reply-To: <20080115201251.GC5699@gollum.tnic>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801162351.29135.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 January 2008, Borislav Petkov wrote:
> ... and finally the last one. Whew! I think we're done here for now. :)
> 
> --
> From: Borislav Petkov <bbpetkov@yahoo.de>
> Date: Tue, 15 Jan 2008 21:01:04 +0100
> Subject: ide-floppy: fix most of the remaining checkpatch.pl issues-v2
> 
> such as
> ERROR: switch and case should be at the same indent
> ERROR: need spaces around that '=' (ctx:VxV)
> ERROR: trailing statements should be on next line
> WARNING: no space between function name and open parenthesis '('
> WARNING: printk() should include KERN_ facility level
> ERROR: That open brace { should be on the previous line
> ERROR: use tabs not spaces
> ERROR: do not use assignment in if condition
> WARNING: braces {} are not necessary for single statement blocks
> ERROR: need space after that ',' (ctx:VxV)
> WARNING: line over 80 characters
> ERROR: do not use assignment in if condition
> ...
> and so on.
> 
> Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>

applied
