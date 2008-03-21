Return-Path: <linux-kernel-owner+w=401wt.eu-S1760777AbYCUABD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760777AbYCUABD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 20:01:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757995AbYCTX4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 19:56:45 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:61980 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758572AbYCTX4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 19:56:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=JLx1P21sjztuyTG4icibNokZTMGEFK4NuI1gbZ85aJV4JYgOvHA13TNFP3i66V+hc+qSVfahL3Nzd6y2e7E/Gg/EI/UQxA27jfJRCamJcbYdThKBlfzqADaT+trLP0HWoaN4KjK1DdXZRQP20rsNTTuSMC5zTrfaQH4HmQbJwzo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 12/17] ide-tape: remove pipelined mode parameters
Date: Fri, 21 Mar 2008 01:09:49 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
References: <1205736090-4435-1-git-send-email-petkovbb@gmail.com> <1205736090-4435-13-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1205736090-4435-13-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803210109.49576.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 March 2008, Borislav Petkov wrote:
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

applied (after patch #14)
