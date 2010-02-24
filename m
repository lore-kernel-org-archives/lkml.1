Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757450Ab0BXSEF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 13:04:05 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:37659
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756344Ab0BXSEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 13:04:01 -0500
X-SpamScore: -5
X-BigFish: VPS-5(zz98dNzz1202hzzz32i87h6bh61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYCY4V-02-PUI-02
X-M-MSG: 
Date: Wed, 24 Feb 2010 19:02:57 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/11] KVM: SVM: Coding style cleanup
Message-ID: <20100224180256.GB3168@amd.com>
References: <1267034360-5907-1-git-send-email-joerg.roedel@amd.com>
 <1267034360-5907-2-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1267034360-5907-2-git-send-email-joerg.roedel@amd.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 24 Feb 2010 18:02:57.0379 (UTC) FILETIME=[9845B330:01CAB57B]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 24, 2010 at 06:59:10PM +0100, Joerg Roedel wrote:
> This patch removes whitespace errors, fixes comment formats
> and most of checkpatch warnings. Now vim does not show
                         ^^^^^^^^
This means actually "errors". The warnings left in this file are
completly 80-chars-per-line related. Two errors are left which don't
make sense to fix.

	Joerg


