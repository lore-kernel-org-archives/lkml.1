Return-Path: <linux-kernel-owner+w=401wt.eu-S1760863AbZGINS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760863AbZGINS2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 09:18:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760757AbZGINSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 09:18:07 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:52855 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760774AbZGINSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 09:18:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=FCc6BSxpKRuV2eWiHSM8YtzNgzTwrJRgIdZeLEgTYXm4Iiwb2bkvZDq1yanUx5vyQX
         B1wAgzfcUwF/qdPAgmcTRY5JpMkHoFXE9uxQNhri2t+5y/2I5tDI6whWLYjIBC9SHv1q
         xFjhFYH/NxgnBm+Q+wWNM24gOs0MZ0x9tvdqw=
Message-ID: <4A55EDCB.7090107@gmail.com>
Date: Thu, 09 Jul 2009 15:16:59 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] staging/rt3070: add support for Linksys WUSB54GC-EU
 v3
References: <4A54FC6B.7000003@gmail.com>
In-Reply-To: <4A54FC6B.7000003@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcin Slusarz wrote:
> According to FCC (*1) and *2 there's really RT2070L inside, but according
> to *2 RT3070 and RT2070 are compatible.
> 
> *1 https://fjallfoss.fcc.gov/oetcf/eas/reports/ViewExhibitReport.cfm?mode=Exhibits&RequestTimeout=500&calledFromFrame=N&application_id=327783&fcc_id=%27Q87-WUSB54GCV3%27
> (look for "Internal Photos")
> *2 http://rt2x00.serialmonkey.com/phpBB/viewtopic.php?f=5&t=5245
> 
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>

Just to be clear - I have tested this patch on real hardware.

Marcin
