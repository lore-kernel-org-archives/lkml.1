Return-Path: <linux-kernel-owner+w=401wt.eu-S1757708AbYBHVEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757708AbYBHVEe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 16:04:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755333AbYBHVDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 16:03:19 -0500
Received: from ag-out-0708.google.com ([72.14.246.243]:56691 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756016AbYBHVDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 16:03:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=n04TyOS/sCUSkvd0cPHqB6rJxxHr7iiERD2kYNvrBsKKPVR4M7vwlmJNH4cV3AQ+tmI/dFADJOmzM1fbfqqL4ec7z21uC803V/IC0TPfESEiHoFdiv4DrqC1RgYGrjp+9BNgN2SxgCFkvPbJbTT0ojyTbbeJTisXLa9AFtbv+I0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [2.6 patch] fix ide/legacy/gayle.c compilation
Date: Fri, 8 Feb 2008 21:33:17 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: geert@linux-m68k.org, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <20080207231226.GD7198@cs181133002.pp.htv.fi>
In-Reply-To: <20080207231226.GD7198@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802082133.17290.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 February 2008, Adrian Bunk wrote:
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

applied
