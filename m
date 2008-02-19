Return-Path: <linux-kernel-owner+w=401wt.eu-S1763041AbYBSWFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763041AbYBSWFs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 17:05:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762086AbYBSWEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 17:04:09 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:1817 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761961AbYBSWEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 17:04:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=ZUPm1sWbZew2c+IlsWmzGy6CoYzAGJ5rpLIf/q0zmBBy29vOJbL1cTVrdejuLtHj0dEgZE+8RyjU+PSrPHD2aDAuhiO37ffVGtazXHO2l1wIuDEcgBOnH+uW48KPZTmR7GkhUo4FJ8JR2cIdu8hAuJOQgQtZYgSXUc1k5shbMGs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: Optiarc DVD RW AD-5200A audio playing
Date: Tue, 19 Feb 2008 23:10:05 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Stefan Bader <stefan.bader@canonical.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
References: <47B5EDB7.5050709@canonical.com> <200802190018.48850.bzolnier@gmail.com> <20080219055233.GA4901@gollum.tnic>
In-Reply-To: <20080219055233.GA4901@gollum.tnic>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802192310.05759.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 February 2008, Borislav Petkov wrote:

[...]

> Author: Borislav Petkov <petkovbb@gmail.com>
> Date:   Sat Feb 16 09:56:36 2008 +0100
> 
>     ide-cd: Enable audio play quirk for Optiarc DVD RW AD-5200A drive
>     
>     Reported-by: Stefan Bader <stefan.bader@canonical.com>
>     Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

applied
