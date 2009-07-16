Return-Path: <linux-kernel-owner+w=401wt.eu-S1757616AbZGPPEK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757616AbZGPPEK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 11:04:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756976AbZGPPEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 11:04:09 -0400
Received: from mail-bw0-f228.google.com ([209.85.218.228]:54687 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756536AbZGPPEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 11:04:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qRKr+CtwLNL/F9Wxe9pJs/UEeCGZV1rsM5s8YsQkP557LlgU8ffbXCeqPlbnxPsD0B
         fP+pwn2+9VLCbihkOSley5SdygVdpSbhE0H3CfsCLA28GP7cyIav/MoWU0u7oLVAe7Ri
         er7mY5Iq0u+xZ0fy2a4xhQY9n0z5QGJvLTVKw=
MIME-Version: 1.0
In-Reply-To: <AFAB8585072C7E48BC5C6F9C87F9B79703BA839300@pdsmsx502.ccr.corp.intel.com>
References: <1247522953-12702-1-git-send-email-tomas.winkler@intel.com>
	 <AFAB8585072C7E48BC5C6F9C87F9B79703BA8388BB@pdsmsx502.ccr.corp.intel.com>
	 <AFAB8585072C7E48BC5C6F9C87F9B79703BA839300@pdsmsx502.ccr.corp.intel.com>
Date: Thu, 16 Jul 2009 18:04:04 +0300
Message-ID: <1ba2fa240907160804g18b1a215w3161c9682db7b35@mail.gmail.com>
Subject: Re: [PATCH] imwc3200: move iwmc3200 SDIO ids to sdio_ids.h
From: Tomas Winkler <tomasw@gmail.com>
To: "Zhu, Yi" <yi.zhu@intel.com>
Cc: "drzeus-list@drzeus.cx" <drzeus-list@drzeus.cx>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 16, 2009 at 3:23 PM, Zhu, Yi <yi.zhu@intel.com> wrote:
>
> > Subject: RE: [PATCH] imwc3200: move iwmc3200 SDIO ids to sdio_ids.h
>
> BTW, subject should be "iwmc3200".

Thanks. I'll address all comments although I'm not sure how to split
the patch since adding SDIO_VENDOR_ID_INTEL to sdio_ids.h it affects
all the drivers anyhow, so I'm suggesting to route it through netdev.

Thanks
Tomas
