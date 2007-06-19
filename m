Return-Path: <linux-kernel-owner+w=401wt.eu-S1760470AbXFSRCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760470AbXFSRCm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 13:02:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751492AbXFSRCd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 13:02:33 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:51142 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757551AbXFSRCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 13:02:31 -0400
From: Oliver Neukum <oliver@neukum.org>
To: linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] Error -71 on device descriptor read/all
Date: Tue, 19 Jun 2007 19:02:07 +0200
User-Agent: KMail/1.9.7
Cc: Chuck Ebbert <cebbert@redhat.com>,
       "Renato S. Yamane" <renatoyamane@mandic.com.br>,
       linux-kernel@vger.kernel.org
References: <4677EBF8.5020104@mandic.com.br> <467801A4.4030004@redhat.com>
In-Reply-To: <467801A4.4030004@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706191902.08173.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 19. Juni 2007 schrieb Chuck Ebbert:

> Try disabling CONFIG_USB_SUSPEND
> 
> [usb developers: what are the drawbacks of doing this?]

Increased power consumption.

	Regards
		Oliver

