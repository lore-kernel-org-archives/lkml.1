Return-Path: <linux-kernel-owner+w=401wt.eu-S1757419AbYECNLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757419AbYECNLj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 09:11:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751850AbYECNL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 09:11:29 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:31236 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbYECNL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 09:11:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=wypmKLk/D7U80ATOtBpaTd+nQ2WCWOQ2fu1i9cmRq3UVx2IczE1/VKOLG99wdcFPVmI6HTGpRN9gprAfRkU8GrxhFxQ7YIau5FLZgfzlu0cFS+0DpUAxPXx0Js2+apkoUVT9rt0IpGxnEpShcufvrAfHTw5Ar3jOepmtV8gOOQ4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [PATCH 2/8] ide: use get_unaligned_* helpers
Date: Sat, 3 May 2008 13:34:17 +0200
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>
References: <1209700376.22362.17.camel@brick>
In-Reply-To: <1209700376.22362.17.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805031334.17850.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 May 2008, Harvey Harrison wrote:
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>

applied
