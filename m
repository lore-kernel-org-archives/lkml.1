Return-Path: <linux-kernel-owner+w=401wt.eu-S1755988AbYLDIu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988AbYLDIu3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 03:50:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752849AbYLDIuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 03:50:16 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:53816 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752AbYLDIuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 03:50:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=oTN1npIOi4vAfJ8ZeZTfMfE6aoxeRZBcPU8a4GOWoZeQ5NcYpPPgqM6Z9lElDiRkTF
         uSEsb6MuVPGZnfeS4YbWx/vn2v6bH/FtgJf9ZFtnNlSGwIdmYWk9audjsVEO8+2RmXSN
         Vj+/rnIg7y8CJlE8B19ASwQ35HjJgmA5/1NLU=
Message-ID: <b637ec0b0812040050g58f3e28dxba5bca8c77bb5a94@mail.gmail.com>
Date: Thu, 4 Dec 2008 09:50:13 +0100
From: "Fabio Comolli" <fabio.comolli@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #12155] Regression in 2.6.28-rc and 2.6.27-stable - hibernate related
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>
In-Reply-To: <bfPM5B8Tx2B.A.MQH.zoxNJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <QFIA5HSHV8B.A.2aG.hoxNJB@chimera>
	 <bfPM5B8Tx2B.A.MQH.zoxNJB@chimera>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Wed, Dec 3, 2008 at 10:58 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.27.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=12155
> Subject         : Regression in 2.6.28-rc and 2.6.27-stable - hibernate related
> Submitter       : Fabio Comolli <fabio.comolli@gmail.com>
> Date            : 2008-11-23 16:17 (11 days old)
> References      : http://marc.info/?l=linux-kernel&m=122745709926361&w=4
>

Unfortunately I don't have much time to test but yes, it was present
last time I tried.
I'll try -rc7-git probably tonight and 2.6.27.8 when -stable team releases it.
