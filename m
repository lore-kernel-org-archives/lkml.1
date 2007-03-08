Return-Path: <linux-kernel-owner+w=401wt.eu-S933041AbXCHU5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933041AbXCHU5W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 15:57:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933133AbXCHU5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 15:57:21 -0500
Received: from mail15.syd.optusnet.com.au ([211.29.132.196]:34827 "EHLO
	mail15.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933041AbXCHU5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 15:57:20 -0500
From: Con Kolivas <kernel@kolivas.org>
To: "Fabio Comolli" <fabio.comolli@gmail.com>
Subject: Re: [ANNOUNCE] RSDL completely fair starvation free interactive cpu scheduler
Date: Fri, 9 Mar 2007 07:57:14 +1100
User-Agent: KMail/1.9.5
Cc: "linux kernel mailing list" <linux-kernel@vger.kernel.org>,
       "ck list" <ck@vds.kolivas.org>
References: <200703041800.53360.kernel@kolivas.org> <b637ec0b0703081225n49d9aa56h3e21c0f9c9bc7039@mail.gmail.com>
In-Reply-To: <b637ec0b0703081225n49d9aa56h3e21c0f9c9bc7039@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703090757.14917.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 March 2007 07:25, Fabio Comolli wrote:
> Hi Con
> It would be nice if you could rebase this patch to latest git or at
> least to 2.6.21-rc3.
> Regards,

Check in http://ck.kolivas.org/patches/staircase-deadline/
There's an -rc3 patch there.

-- 
-ck
