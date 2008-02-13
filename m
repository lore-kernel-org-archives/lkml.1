Return-Path: <linux-kernel-owner+w=401wt.eu-S934861AbYBMWCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934861AbYBMWCb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 17:02:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934388AbYBMVu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 16:50:56 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:17900 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934920AbYBMVuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 16:50:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=JlRIl2SEEVI72sxouSQUas+S8f0lgZGin2IdsAap3rGnRn30D75ZKSM2F8IoEHZkOmzy57XCEGBia/0VYOzC9o8hRT24jydYPd2OYzABW2w7YomAGp4YvUCp06Aoud+J9XN73cTZ39ZHu5Ny8bArYJf8l+o6dFNcRBsfdlVeeUE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 1/2] ide: use generic ATAPI packet command flags in ide-{floppy,tape}
Date: Wed, 13 Feb 2008 22:44:31 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
References: <1202923544-19551-1-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1202923544-19551-1-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802132244.31433.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 February 2008, Borislav Petkov wrote:
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

applied
