Return-Path: <linux-kernel-owner+w=401wt.eu-S935708AbYBCADV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935708AbYBCADV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 19:03:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932787AbYBCAAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 19:00:24 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:56231 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935718AbYBCAAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 19:00:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=u9YsmNSv9JuGdtoy4k4p6o/Qi28ASIr6MgfFaFdV+NzyDfqbC8/ls9Qh0CR0A2tlNXWgxyH+PpmdSnCXcB2quwbSHAxAmEZNkw9Oc+Skz3ko63M9Dqk5022fAAjJYRUan2fDJKHUKP90Kt5ITy7EsSi6M+5RXfqZu2oiP+fkCCc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 27/32] ide-tape: remove idetape_increase_max_pipeline_stages()
Date: Sun, 3 Feb 2008 01:07:24 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <bbpetkov@yahoo.de>
References: <1201427300-3954-1-git-send-email-petkovbb@gmail.com> <1201427300-3954-22-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1201427300-3954-22-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802030107.24660.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 27 January 2008, Borislav Petkov wrote:
> From: Borislav Petkov <bbpetkov@yahoo.de>
> 
> This function was being used only at one place so fold it in there.
> 
> Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>

This change is fine but depends on previous patches so I can't apply it.

Please move it at the beginning of the series and resubmit.

Thanks,
Bart
