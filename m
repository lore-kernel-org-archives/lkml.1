Return-Path: <linux-kernel-owner+w=401wt.eu-S1763482AbYBMWDF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763482AbYBMWDF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 17:03:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934422AbYBMVu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 16:50:58 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:16685 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934928AbYBMVuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 16:50:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=hsX/2ZmJ4zScJwT0OCBGgI1bbzdKNVNN8ev6ZFEa2HQEtSWUipEV5/+j3F+VxwFHMa/uXuRBUf39SjeJvi+d2fgpYHd7GEkekRgPmTtzpwRao2LNXOCdhZzwOGMXGe/8htGeXInFmynMpl+BDNbgm+aAmVizfdOMB8tZRZhr6Rw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 2/2] ide-scsi: do non-atomic pc->flags testing
Date: Wed, 13 Feb 2008 22:44:50 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
References: <1202923544-19551-1-git-send-email-petkovbb@gmail.com> <1202923544-19551-2-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1202923544-19551-2-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802132244.50487.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 February 2008, Borislav Petkov wrote:
> ...also, convert ide-scsi to using the generic pc->flags defines.
> 
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

applied
