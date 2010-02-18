Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758539Ab0BRQbc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 11:31:32 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:50394
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755850Ab0BRQba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 11:31:30 -0500
X-SpamScore: -28
X-BigFish: VPS-28(zz1432R98dN936eM9371Pzz1202hzzz32i6bh87h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KY1PVO-01-A97-02
X-M-MSG: 
Date: Thu, 18 Feb 2010 17:30:28 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Alexander Graf <agraf@suse.de>, Marcelo Tosatti <mtosatti@redhat.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/10] KVM: SVM: Make lazy FPU switching work with
 nested svm
Message-ID: <20100218163027.GS22141@amd.com>
References: <1266493115-28386-1-git-send-email-joerg.roedel@amd.com>
 <1266493115-28386-10-git-send-email-joerg.roedel@amd.com>
 <66C13ED8-1D62-4647-9633-D032ADD5DDA9@suse.de>
 <4B7D54CA.40005@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4B7D54CA.40005@redhat.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 18 Feb 2010 16:30:28.0531 (UTC) FILETIME=[AE6C3030:01CAB0B7]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 18, 2010 at 04:55:06PM +0200, Avi Kivity wrote:
> On 02/18/2010 04:51 PM, Alexander Graf wrote:
> >On 18.02.2010, at 12:38, Joerg Roedel wrote:
> >
> >>TDB.
> >TDB? That's not a patch description.
> >
> 
> Short for "To De Befined", I presume.

Ups. I just forgot to give this patch a right commit message. I add one
for the next post.

	Joerg


