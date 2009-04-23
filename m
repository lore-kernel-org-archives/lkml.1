Return-Path: <linux-kernel-owner+w=401wt.eu-S1753272AbZDWAqI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272AbZDWAqI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 20:46:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751732AbZDWAp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 20:45:57 -0400
Received: from rcsinet13.oracle.com ([148.87.113.125]:61627 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbZDWAp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 20:45:56 -0400
Date: Wed, 22 Apr 2009 17:40:10 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Karsten Keil" <Karsten-Keil@t-online.de>
Cc: linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
       David Miller <davem@davemloft.net>, tilman@imap.cc,
       isdn4linux@listserv.isdn4linux.de, i4ldeveloper@listserv.isdn4linux.de,
       netdev@vger.kernel.org
Subject: Re: [PATCH 0/3] [ISDN] Documentation patchset
Message-Id: <20090422174010.1d6a859a.randy.dunlap@oracle.com>
In-Reply-To: <cover.1240410708.git.keil@b1-systems.de>
References: <cover.1240410708.git.keil@b1-systems.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A01020A.49EFBA38.00A3:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Apr 2009 16:31:48 +0200 Karsten Keil wrote:

> Add some useful documentation for the ISDN subsystem.
> Orignal patches are from Tilman Schmidt.
> I fixed some whitespace issues and added the URL for the CAPI 2.0 spec.

Looks good.  Thanks.

Reviewed-by: Randy Dunlap <randy.dunlap@oracle.com>


> Karsten Keil (1):
>   Add reference to CAPI 2.0 standard
> 
> Tilman Schmidt (2):
>   update Documentation/isdn/00-INDEX
>   Documentation/isdn/INTERFACE.CAPI
> 
>  Documentation/isdn/00-INDEX       |   17 +++-
>  Documentation/isdn/INTERFACE.CAPI |  208 +++++++++++++++++++++++++++++++++++++
>  drivers/isdn/capi/kcapi.c         |  171 ++++++++++++++++++++++++++++++
>  3 files changed, 392 insertions(+), 4 deletions(-)
>  create mode 100644 Documentation/isdn/INTERFACE.CAPI


---
~Randy
