Return-Path: <linux-kernel-owner+w=401wt.eu-S1760015AbYCBTFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760015AbYCBTFs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 14:05:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757748AbYCBTDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 14:03:41 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:37702 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758884AbYCBTDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 14:03:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=v0MGIpqT6rwd5FE1nyBEwBRfOmJc/M/NgReqHAE+O4t56fniJ76qXIW9rvVnrUHGyl6kTeDMArGXp6nAFD6SUl1mzHT/gPGV9kXe+FubD5QbcbMgV9cKFI9gXF2uKdHZOe+opNl3htSSoQFCRIrVPDyJfD8BqOgeROEutFETyc4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 06/24] ide-tape: remove unused stage-parameter from idetape_copy_stage_to_user
Date: Sun, 2 Mar 2008 20:15:33 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
References: <1204361928-30229-1-git-send-email-petkovbb@gmail.com> <1204361928-30229-7-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1204361928-30229-7-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803022015.33662.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 01 March 2008, Borislav Petkov wrote:
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

please move it at the beginning of the patch series

Lets stop at this patch for now and get changes from patches #2-6
into IDE tree first before moving on patches #7-24.

Thanks,
Bart
