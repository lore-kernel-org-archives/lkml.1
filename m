Return-Path: <linux-kernel-owner+w=401wt.eu-S1759044AbYCBTDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759044AbYCBTDt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 14:03:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757885AbYCBTDd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 14:03:33 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:37615 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758787AbYCBTDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 14:03:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=fiXMJTFWg7LgFoUGYVvCBBgzu6i3YEguKSSHPLs4vaGG76kWNETGXAM6bYlQ1TTzgtLjMpYDLE+TlvF5DKn1+5ygj2JBixwomFIWDtkPKnFti0ysw9Sg3xZKuFbspG4WjnmAPn4W+1bHYddJ8d7linVo5Ib1k+0kxU4McU50Vt8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 01/24] ide-tape: remove idetape_pipeline_active()
Date: Sun, 2 Mar 2008 19:21:30 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
References: <1204361928-30229-1-git-send-email-petkovbb@gmail.com> <1204361928-30229-2-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1204361928-30229-2-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803021921.30696.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 01 March 2008, Borislav Petkov wrote:
> This function was simply a wrapper for a test_bit() macro so remove it and
> use the macro instead.
> 
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

applied
