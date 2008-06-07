Return-Path: <linux-kernel-owner+w=401wt.eu-S1758709AbYFGKFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758709AbYFGKFe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 06:05:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755400AbYFGKF1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 06:05:27 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:22010 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754677AbYFGKF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 06:05:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=l/o0uQrQa639Pi5Ju/iWilMFq57ZGDBBOMTmRT27GVG3LYWveLW1hCVOu4SwgWofr0
         DeEztf87qEHZTRp0rBk5AWWVeJf91Lv0Yr4tsTiKHPjZQt0DzBIa+s0ACPKQBW9I/cJb
         ZeiaL5AdlFbL4N4DLqbaHYRhgamUX0PnRCeyY=
Message-ID: <84144f020806070305q33dd341wfbb36138d7b533a@mail.gmail.com>
Date: Sat, 7 Jun 2008 13:05:23 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Matthew Garrett" <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] Add backlight driver for Nvidia-based Apple Macbook Pros
Cc: "Andrew Morton" <akpm@linux-foundation.org>, rpurdie@rpsys.net,
       linux-kernel@vger.kernel.org, mzxreary@0pointer.de
In-Reply-To: <20080607095839.GA803@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080607025436.GB24254@srcf.ucam.org>
	 <20080606230745.304d116b.akpm@linux-foundation.org>
	 <20080607095839.GA803@srcf.ucam.org>
X-Google-Sender-Auth: b056b893ea119259
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew,

On Fri, Jun 06, 2008 at 11:07:45PM -0700, Andrew Morton wrote:
>> Did this patch have appropriate attribution and signoffs?

On Sat, Jun 7, 2008 at 12:58 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> Pommed is GPLv2.

Andrew has required signoffs from all copyright holders of a patch in
the past regardless of that.
