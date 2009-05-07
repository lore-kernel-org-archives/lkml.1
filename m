Return-Path: <linux-kernel-owner+w=401wt.eu-S1756383AbZEGPvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756383AbZEGPvX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 11:51:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbZEGPvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 11:51:10 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:50491 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751693AbZEGPvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 11:51:09 -0400
Date: Thu, 7 May 2009 11:40:19 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Alok Kataria <akataria@vmware.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Reduce the default HZ value
In-Reply-To: <4A02FE91.8070006@zytor.com>
Message-ID: <alpine.DEB.1.10.0905071136520.10171@qirst.com>
References: <1241462661.412.8.camel@alok-dev1> <4A00ADDE.9000908@zytor.com> <1241560625.8665.17.camel@alok-dev1> <alpine.DEB.1.10.0905071010170.24528@qirst.com> <20090507161440.5b9c067d@lxorguk.ukuu.org.uk> <4A02FE91.8070006@zytor.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 May 2009, H. Peter Anvin wrote:

> Amen.  Also, "using HZ as a unit of measurement must die, too."

Dont think that is a problem if we had a convention of seeing 1 HZ as an
interval of 1 ms or so.




